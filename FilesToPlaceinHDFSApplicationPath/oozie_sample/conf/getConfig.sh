##!/bin/sh
##provide required parameters
echo "jobgroup=appl1"
echo "HiveDBName=<DB1>"
echo "Source=<DB.table>"
echo "myDestTable=RTL_BANK"
echo "keyTabFile=/oozie_sample/beeline_conf.sh"
echo "sshPath=/appl1"
echo "sshPath=/oozie"
echo "sshScripts=jobs/script"
echo "Scripts=scripts"
echo "sshSQL=jobs/sql"
echo "hiveRecCountSQL=hiveRecCountSQL.sql"
echo "hiveFileGenSQL=sample.sql"
echo "hivePrevCurProcDtSQL=_PrevCurProcDt.sql"
echo "retryaccount=0"
echo "retrycustomer=0"
echo "retrycustmast=0"
#echo "hiveFileBal=dml_fdn_cml_custacct_genBalFile.sql"
## targetDir, Not in use
echo "targetDir=/oozie"
# opp to streamline hdfsPath + myFolder
echo 'hdfsPath=/user/oozie_sample/appl1'
echo 'localPath=/appl1/scripts'
#echo 'fileName=f'
