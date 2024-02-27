# Introduction
Cluster Action scripts for dbvagentmanager and dbvcontrol. These scripts are used to add the automatic startup/shutdown and relocate the agentmanager services from one node to other.
To enable easy SEHA failover for dbvagentmanager we recommend to integrate them into Oracle Grid by using action script.

# Linux
Use `dbvcrs.sh` for Linux platform. This is a single action script for both dbvagentmanager and dbvcontrol.

## Script Usage
Upload the script to directory `/dbvisit/app/standbymp/bin` (`$DBVISIT_BASE/standbymp/bin`) and set correct privileges:
```
$cd /dbvisit/app/standbymp/bin  
$chmod +x dbvcrs.sh
```
Now we can finally create resource for dbvagentmanager. As root user execute:
```
# . oraenv
ORACLE_SID = [root] ? +ASM1
//The below command must be in a single line
# crsctl add resource dbvagentmanager -type generic_application -attr "START_PROGRAM='/dbvisit/app/standbymp/bin/dbvcrs.sh start dbvagentmanager',STOP_PROGRAM='/dbvisit/app/standbymp/bin/dbvcrs.sh stop dbvagentmanager',CHECK_PROGRAMS='/dbvisit/app/standbymp/bin/dbvcrs.sh check dbvagentmanager',CLEAN_PROGRAM='/dbvisit/app/standbymp/bin/dbvcrs.sh clean dbvagentmanager', CHECK_INTERVAL=10,START_DEPENDENCIES='hard(dbvisit-vip2178) pullup(dbvisit-vip2178) attraction(dbvisit-vip2178)',STOP_DEPENDENCIES='hard(dbvisit-vip2178)',ACL='owner:oracle:rwx,pgrp:oinstall:rwx,other::r--',PLACEMENT='favored',HOSTING_MEMBERS='czrlin0217 czrlin0218'"
```
The locations provided must match your $DBVIST_BASE location and the servers must changed with your own server names ( node1, node2).

## Additional Information

Please remember to create the VIP before adding the action scripts as the VIP will also be relocated when one node goes down. Script for creating VIP (This has to be executed as root user).
```
#. oraenv [+ASM1]
#appvipcfg create -network=1 -ip=192.168.8.12 -vipname=dbvisit-vip2178 -user=root
#crsctl setperm resource dbvisit-vip2178 -u user:oracle:r-x
#crsctl setperm resource dbvisit-vip2178 -u user:grid:r-x
#crsctl start resource dbvisit-vip2178 -n czrlin0217
```
For detailed user guide explanations, please check the below link:
https://dbvisit.atlassian.net/wiki/spaces/DSMP/pages/3500081153/Oracle+SEHA+and+RAC+on+Linux

## Example Output
When the VIP is relocated to passive/second node the agentmanager will automatically be started in the passive/second node as well.
```
$ crsctl relocate resource dbvisit-vip2178 -f
CRS-2673: Attempting to stop 'dbvagentmanager' on 'czrlin0217'
CRS-2677: Stop of 'dbvagentmanager' on 'czrlin0217' succeeded
CRS-2673: Attempting to stop 'dbvisit-vip2178' on 'czrlin0217'
CRS-2677: Stop of 'dbvisit-vip2178' on 'czrlin0217' succeeded
CRS-2672: Attempting to start 'dbvisit-vip2178' on 'czrlin0218'
CRS-2676: Start of 'dbvisit-vip2178' on 'czrlin0218' succeeded
CRS-2672: Attempting to start 'dbvagentmanager' on 'czrlin0218'
CRS-2676: Start of 'dbvagentmanager' on 'czrlin0218' succeeded
```

# Windows
Use `dbvcrs.bat` for Windows platform.

## Script Usage
Upload the script `dbvcrs.bat` to directory `C:\dbvisit\app\bin`

```
cd C:\Temp
cp dbvcrs.bat C:\dbvisit\app\bin
```
Do NOT change the script name nor script location. If you do, you will have to make on your own adjustments in the script and in the cluster commands.

On the second node install the dbvagentmanager service manually
```
C:\Users\Administrator>C:\dbvisit\app\bin\dbvagentmanager service install --user "dbvisit\oracle"
```
Set the startup mode to Manual
```
C:\Users\Administrator>sc config dbvagentmanager start=demand
[SC] ChangeServiceConfig SUCCESS
C:\Users\Administrator>sc.exe config dbvagentmanager password= "mysecret"
[SC] ChangeServiceConfig SUCCESS
```
Set the permissions to full control on service dbvagentmanager for “Service Logon User” and “Interactively logged-on user”:
```
sc sdset dbvagentmanager "D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;IU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;SU)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)"
[SC] SetServiceObjectSecurity SUCCESS
```
**Do NOT start the service on 2nd node**

Create the cluster resource
```
crsctl add resource dbvagentmanager -type generic_application -attr "START_PROGRAM='/dbvisit/app/bin/dbvcrs.bat start dbvagentmanager',STOP_PROGRAM='/dbvisit/app/bin/dbvcrs.bat stop dbvagentmanager',CHECK_PROGRAMS='/dbvisit/app/bin/dbvcrs.bat check dbvagentmanager',CLEAN_PROGRAM='/dbvisit/app/bin/dbvcrs.bat clean dbvagentmanager',CHECK_INTERVAL=10,START_DEPENDENCIES='hard(dbvisit-vip34) pullup(dbvisit-vip34) attraction(dbvisit-vip34)',STOP_DEPENDENCIES='hard(dbvisit-vip34)',PLACEMENT='favored',HOSTING_MEMBERS='w19ora19seha3 w19ora19seha4',ACL='owner:dbvisit\oracle:rwx,pgrp::r-x,other::r--'"
```
Create the dbvcontrol cluster resource
```
crsctl add resource dbvcontrol -type generic_application -attr "START_PROGRAM='/dbvisit/app/bin/dbvcrs.bat start dbvcontrol',STOP_PROGRAM='/dbvisit/app/bin/dbvcrs.bat stop dbvcontrol',CHECK_PROGRAMS='/dbvisit/app/bin/dbvcrs.bat check dbvcontrol',CLEAN_PROGRAM='/dbvisit/app/bin/dbvcrs.bat clean dbvcontrol',CHECK_INTERVAL=10,START_DEPENDENCIES='hard(dbvisit-vip12) pullup(dbvisit-vip12) attraction(dbvisit-vip12)',STOP_DEPENDENCIES='hard(dbvisit-vip12)',PLACEMENT='favored',HOSTING_MEMBERS='w22ora19seha1 w22ora19seha2',ACL='owner:dbvisit\oracle:rwx,pgrp::r-x,other::r--'"
```
## Additional Information
Make sure the Oracle Grid Infrastructure is deployed as per Oracle documentation. The group membership for oracle and grid users needs to be correct. Dbvisit supports cluster role separation (oracle and grid user) as well as simple configuration (oracle user only)

Step to create the VIP
In our example, the pre-allocated VIP for our SEHA cluster is "172.16.17.253," and we decided to assign the DNS name "dbvisit-vip34". To create a new VIP address
```
C:\Users\Administrator>appvipcfg create -network=1 -ip=192.168.18.253 -vipname=dbvisit-vip34 -user=dbvisit\oracle
Using configuration parameter file: C:\app\grid\product\19.0.0.0\gridhome_1\crs\install\crsconfig_params
The log of current session can be found at:
  C:\app\orabase\crsdata\w19ora19seha3\scripts\appvipcfg.log
```
Verify the VIP
```
C:\Users\Administrator>crsctl status resource dbvisit-vip34
NAME=dbvisit-vip34
TYPE=app.appviptypex2.type
TARGET=OFFLINE
STATE=OFFLINE

C:\Users\Administrator>crsctl start resource dbvisit-vip34
CRS-2672: Attempting to start 'dbvisit-vip34' on 'w19ora19seha3'
CRS-2676: Start of 'dbvisit-vip34' on 'w19ora19seha3' succeeded
```