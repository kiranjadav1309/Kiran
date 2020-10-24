#!/bin/bash
# Read apllication Configs

# Step1 Initialise keytab credentials that has access to Oozie and HDFS paths
#Step2 Initialize log path and file
myLogFile="/<path for log file>/log/wf_oozie_sample.out"

# Truncate Log File
> $myLogFile
tlStatus=$?
if [ $tlStatus -ne 0 ]
then
  echo "Truncate Log File Failed: "$myLogFile >&2
  exit 1
fi


#Step3 submit oozie workflow using re-usable script.
#Step4 Pass the worklfow name here oozie_sample sis the argument passed, however later it will be prefixedwith wf so the workflow name is wf_oozie_sample
chmod 766 $myLogFile
bash /reusable_submit_script/SubmitWorkflow.sh /<path for properties file>/Oozie_Sample.properties oozie_sample $myLogFile

wfStatus=$?

if [ $wfStatus -ne 0 ]
then
  echo "workflow Failed" >&2
echo "
  This is an auto generated email.Please don't reply to this email." | mailx -s "Job1 step1 job failed" email@email.com
  exit 1
else
  echo "workflow completed successfully
  This is an auto generated email.Please don't reply to this email." | mailx -s "Job1 step1 successfull" email@email.com
exit $wfStatus
fi
