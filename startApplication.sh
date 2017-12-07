#!/bin/bash
OfflineRetentionCoordinator=$1
arkMaster=$(cat "$OfflineRetentionCoordinator" | grep arkMaster | sed 's/.*=//')
cmHost=$(cat "$OfflineRetentionCoordinator" | grep cmhost | sed 's/.*=//')
cmCluster=$(cat "$OfflineRetentionCoordinator" | grep cmcluster | sed 's/.*=//')
oozieConfig=`python clouderaConfigOozie.py ${cmHost} "${cmCluster}"`
export OOZIE_URL=$(echo ${oozieConfig} | awk '{print $1}')
nameNode=$(echo ${oozieConfig} | awk '{print $2}')
jobTracker=$(echo ${oozieConfig} | awk '{print $3}')
export OOZIE_CLIENT_OPTS='-Djavax.net.ssl.trustStore=/opt/cloudera/security/jks/truststore.jks'
echo -e "***** Script starts here *****"
if [[ $1 == *.properties ]];
then
 echo "Properties File Path from argument: $OfflineRetentionCoordinator"
else
echo "Error: Coordinator properties file needs to be send to the script as argument"
echo -e "***** Script ends here *****"
exit
fi

# Update the start and end time in the coordinator.property file
replaceStartTime="s/^startTime=.*/startTime="
replaceEndTime="s/^endTime=.*/endTime="
replaceNamenodeString="s@^nameNode=.*@nameNode=$nameNode@"
replaceJobtrackerString="s@^jobTracker=.*@jobTracker=$jobTracker@"

currentHour=$(date -u +%H)
if test $currentHour -eq 23
        then
                newStartTime=$(date -u --date='1 day' +%Y-%m-%dT23:00Z)
        else
                newStartTime=$(date -u  +%Y-%m-%dT23:00Z)
fi

replaceStartTime="$replaceStartTime$newStartTime\r/"
newEndDate=$(date -u --date='3 year' +%Y-%m-%dT23:00Z)
replaceEndTime="$replaceEndTime$newEndDate\r/"

$(sed -i -e $replaceEndTime -e $replaceStartTime -e $replaceNamenodeString -e $replaceJobtrackerString $OfflineRetentionCoordinator )

runningJobId=$(oozie jobs -jobtype coord 2>/dev/null | egrep 'EEARetention_Coordinator.*RUNNING' | grep -Eo '^[^ ]+')

if [ -z "$runningJobId" ];
then
        echo "EEA-Retention Coordinator is not running."
else
        echo "EEA-Retention Coordinator is running(Job ID: $runningJobId). Killing it prior to restarting."
        oozie job -kill $runningJobId  2>/dev/null
fi

runningJobId=$(oozie jobs -jobtype coord 2>/dev/null | egrep 'EEARetention_Coordinator.*PREP' | grep -Eo '^[^ ]+')

if [ -z "$runningJobId" ];
then
        echo "EEA-Retention coordinator is not under PREP status"
else
        echo "EEA-Retention coordinator is under PREP(Job ID: $runningJobId).Killing it."
        oozie job -kill $runningJobId  2>/dev/null
fi

echo "Now Starting the new Coordinator job"
oozie job -config $OfflineRetentionCoordinator -run

echo -e "***** Script ends here *****"