#!/bin/bash
ApplicationCoordinator=$1
masterNode=$(cat "$ApplicationCoordinator" | grep masterNode | sed 's/.*=//')
# Line 5 to 9 is related to cloudera installation. 
cmHost=$(cat "$ApplicationCoordinator" | grep cmhost | sed 's/.*=//')
cmCluster=$(cat "$ApplicationCoordinator" | grep cmcluster | sed 's/.*=//')
oozieConfig=`python clouderaConfigOozie.py ${cmHost} "${cmCluster}"`
export OOZIE_URL=$(echo ${oozieConfig} | awk '{print $1}')
export OOZIE_CLIENT_OPTS='-Djavax.net.ssl.trustStore=/opt/cloudera/security/jks/truststore.jks'
# If you have mapr installation then uncomment below lines 11 & 12 and comment lines 5 to 9
# o=$(maprcli urls -name oozie | tail -1)
# export OOZIE_URL=$(echo $o | sed 's/ //g')
# For other installations, please refer Apache Oozie documentation -> How to configure OOZIE_URL

runningJobId=$(oozie jobs -jobtype coord 2>/dev/null | egrep 'Application_Coordinator.*RUNNING' | grep -Eo '^[^ ]+')

if [ -z "$runningJobId" ];
then
        echo "Application Coordinator is not Running."
else
        echo "Application Coordinator is running(Job ID: $runningJobId). Killing it."
        oozie job -kill $runningJobId  2>/dev/null
fi

runningJobId=$(oozie jobs -jobtype coord 2>/dev/null | egrep 'Application_Coordinator.*PREP' | grep -Eo '^[^ ]+')

if [ -z "$runningJobId" ];
then
        echo "Application coordinator is not under PREP status"
else
        echo "Application coordinator is under PREP status(Job ID: $runningJobId). Killing it."
        oozie job -kill $runningJobId  2>/dev/null
fi
