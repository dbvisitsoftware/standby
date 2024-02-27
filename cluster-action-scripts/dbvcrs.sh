#!/bin/bash
#
# Dbvisit Multiplatform Action Script Used to start & stop Dbvisit in Oracle Grid environments
# Version 1.0.2
#
# 1.0.1: 22nd August 2022 - added variable SRVM_PROPERTY_DEFS due to issues with different language settings
# 1.0.2: 23rd February 2023 - changed stop and clean procedure to pgrep
# 1.0.3: 15th June 2023 - changed to accomodate multiple standbymp bases

# set following to ensure oraenv is picked up from /usr/local/bin
export PATH=/usr/local/bin:$PATH

# set DBVISIT variable to correspond to script location and executable

DBV_BIN_BASE=$(dirname "$0")
export DBV_BIN_BASE=$(cd "$DBV_BIN_BASE" && pwd)
#substract bin directory and add oracle - dbvctl is in DBVISIT_BASE/oracle dir not in bin
export DBV_ORA_BIN_BASE=${DBV_BIN_BASE%/*}/oracle
export DBV_EXEC=$2
export USER=oracle
export SRVM_PROPERTY_DEFS="-Duser.language=en"

# set grep string to match and to not match

export DBV_GREP_MATCH="${DBV_BIN_BASE}/${DBV_EXEC} service run"
export DBV_GREP_NOMATCH="grep|dbvcrs"


# SCRIPT FUNCTIONS

kill_helpers(){
c=0
# until any dbvctl or dbvhelper processes exist and do not do it endlessly
while [[ $(pgrep -f ${DBV_BIN_BASE}/dbvctl | wc -l) -gt 0 ]] || [[ $(pgrep -f ${DBV_BIN_BASE}/dbvhelper | wc -l) -gt 0 ]]
do
  pkill -f ${DBV_BIN_BASE}/dbvhelper
  sleep 1
  pkill -f ${DBV_ORA_BIN_BASE}/dbvctl
  ((c++)) && ((c==10)) && break
  sleep 1
done
}

start_dbvisit ()

{

echo "Starting Dbvisit ${DBV_EXEC}"

nohup ${DBV_BIN_BASE}/${DBV_EXEC} service run >/dev/null 2>&1 &
sleep 1
}

check_dbvisit ()

{

NUM_PROC=`ps -ef | egrep "${DBV_GREP_MATCH}" | egrep -v "${DBV_GREP_NOMATCH}" | wc -l`

if [ ${NUM_PROC} -eq 1 ]; then
        echo "Submitted check for ${DBV_EXEC} with result running correctly, return 0"
        exit 0;
else
        echo "Submitted check for ${DBV_EXEC} with result not running correctly, return 1"
        exit 1;
fi

}

stop_dbvisit ()

{

#check the count of dbvagentmanager processes
DBV_CNT=`pgrep -f "${DBV_GREP_MATCH}" | wc -l`

if [ $DBV_CNT -eq 1  ]; then

        pkill -f "${DBV_GREP_MATCH}"
        if [ "$DBV_EXEC" = "dbvagentmanager" ]; then
                kill_helpers
        fi
        #pkill -f "${DBV_GREP_MATCH}"

        sleep 1

        exit 0;
else
        exit 1;
fi

}

clean_dbvisit ()

{

pkill -9 -f "${DBV_GREP_MATCH}"
if [ "x$DBV_EXEC" = "xdbvagentmanager" ]; then
  kill_helpers
  pkill -f ${DBV_BIN_BASE}/dbvhelper
  sleep 1
  pkill -f ${DBV_ORA_BIN_BASE}/dbvctl
  sleep 1
fi
pkill -9 -f "${DBV_GREP_MATCH}"

exit 0

}

# MAIN

case "$1" in
        'start')
        start_dbvisit
        check_dbvisit
     ;;

        'stop')
        stop_dbvisit
     ;;

        'check')
        check_dbvisit
        ;;

        'clean')
        clean_dbvisit
     ;;
esac
