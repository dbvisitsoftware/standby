#!/bin/bash

writelog ()
{
LOGTIME=`date +"%Y/%m/%d %H:%M:%S.%3N"`
echo $LOGTIME " " $1 >> $LOG
}

case ${1} in
        pre)
        LOG="/tmp/dbv_prepost.log"
        case ${2} in
                3)
                writelog "Starting Database Session Precheck for Graceful Switchover"
                USER=$(sqlplus -s "/as sysdba" <<EOF
set serveroutput on
set verify off
set echo off
set feed off
set head off
select count(distinct(username)) from gv\$session where username <> 'SYS';
EOF
)

                writelog "found $USER connected users"
                if [ $USER != 0 ]
                then
                        writelog "aborting switchover because user session, exiting with code 1"
                        exit 1
                fi
                ;;
        esac
;;
esac