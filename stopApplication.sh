#!/bin/bash
SCHEDULER_OfflineRetentionCoordinator=$1
arkMaster=$(cat "$SCHEDULER_OfflineRetentionCoordinator" | grep arkMaster | sed 's/.*=//')
cmHost=$(cat "$SCHEDULER_OfflineRetentionCoordinator" | grep cmhost | sed 's/.*=//')
cmCluster=$(cat "$SCHEDULER_OfflineRetentionCoordinator" | grep cmcluster | sed 's/.*=//')
oozieConfig=`python clouderaConfigOozie.py ${cmHost} "${cmCluster}"`
export OOZIE_URL=$(echo ${oozieConfig} | awk '{print $1}')
export OOZIE_CLIENT_OPTS='-Djavax.net.ssl.trustStore=/opt/cloudera/security/jks/truststore.jks'

runningJobId=$(oozie jobs -jobtype coord 2>/dev/null | egrep 'EEARetention_Coordinator.*RUNNING' | grep -Eo '^[^ ]+')

if [ -z "$runningJobId" ];
then
        echo "EEA-Retention Coordinator is not Running."
else
        echo "EEA-Retention Coordinator is running(Job ID: $runningJobId). Killing it."
        oozie job -kill $runningJobId  2>/dev/null
fi

runningJobId=$(oozie jobs -jobtype coord 2>/dev/null | egrep 'EEARetention_Coordinator.*PREP' | grep -Eo '^[^ ]+')

if [ -z "$runningJobId" ];
then
        echo "EEA-Retention coordinator is not under PREP status"
else
        echo "EEA-Retention coordinator is under PREP status(Job ID: $runningJobId). Killing it."
        oozie job -kill $runningJobId  2>/dev/null
fi