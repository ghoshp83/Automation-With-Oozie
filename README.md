# Automation-With-Oozie
Application management, trigger and monitor through Oozie coordinator and workflows

This application is to create an oozie job using oozie coordinators and workflows which will trigger/execute a java/scala/python application. Using oozie coordinators, we can automate an application management i.e. application start, stop, schedule and monitor. 

<B> How to use : </B>

1. To create/start the oozie job use this command -> bash startApplication.sh application_coordinator.properties
2. To kill/stop the oozie job use this command -> bash stopApplication.sh
3. Before starting an oozie job, one need to assign the OOZIE_URL like below ->
   
   export OOZIE_URL=http://testserver.pralay.org:11000/oozie
