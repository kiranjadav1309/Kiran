#!/bin/bash

jobPropertiesName=$1
myScriptFolder=$2
myLogFile=$3

echo "jobPropertiesName: "$jobPropertiesName >> $myLogFile
echo "myScriptFolder: "$myScriptFolder >> $myLogFile
echo "myLogFile: " $myLogFile >> $myLogFile
echo "" >> $myLogFile

# Read oozie Configs
. /retail_banking/jobs/conf/oozie_config.sh

#Execute job and Get the job id
echo "oozie job -oozie "$OozieURL" -config "$jobPropertiesName" -run -DnameNode="$nameNode" -DjobTracker="$jobTracker" -DresourceManager="$resourceManager" -DjdbcUrl="$JDBCUrl" -Dhs2Principal="$hs2Principal" -DqueueName="$QueueName"  -DhdpVersion="$HdpVersion" -DzeroCountTblVar="$ZeroCountTblVar" -DsshHost="$SSHHost" -DmyFolder="$myScriptFolder >> $myLogFile
echo "" >> $myLogFile

JobID=`oozie job -oozie $OozieURL -config $jobPropertiesName -run -DnameNode=$nameNode -DjobTracker=$jobTracker -DresourceManager=$resourceManager -DjdbcUrl=$JDBCUrl -Dhs2Principal=$hs2Principal -DqueueName=$QueueName  -DhdpVersion=$HdpVersion -DzeroCountTblVar=$ZeroCountTblVar -DsshHost=$SSHHost -DmyFolder=$myScriptFolder`
oozStatus=$?

if [ $oozStatus -ne 0 ]
then
  echo "Oozie Job Run Command Failed" >&2
  exit 1
fi

#JobID="${JobID/'job: '/}"
JobID=$(echo $JobID | sed 's/job: *//')

echo "Started. Job: "$JobID
OutputResult=$(oozie job -oozie $OozieURL -info $JobID  | grep -i 'Status *:')

# oozie job -oozie $OozieURL -info $JobID

while [[  $OutputResult == *RUNNING* ]]; do

    echo "Running: "$JobID
    #oozie job -oozie $OozieURL -info $JobID
    echo $OutputResult >> $myLogFile
    sleep 10s
    OutputResult=$(oozie job -oozie $OozieURL -info $JobID  | grep -i 'Status *:')
done

if [[ $OutputResult != *SUCCEEDED* ]]
then
    oozie job -oozie $OozieURL -log $JobID  >&2 | tee $myLogFile
fi

jobInfo=$(oozie job -oozie $OozieURL -info $JobID)

if [[ $OutputResult == *SUCCEEDED* ]]
	then
		#echo "Status=SUCCEEDED" | tee $myLogFile
		#echo $jobInfo | tee $myLogFile
		if [ -f $myLogFile ]; then rm $myLogFile; fi
		exit 0
	else
		echo "Status=UNKNOWN" >&2 | tee $myLogFile
		echo $jobInfo | tee $myLogFile
		exit 1
fi
