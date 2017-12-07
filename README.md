# Automation-With-Oozie
Application management, trigger and monitor through Oozie coordinator and workflows

This application is to create an oozie job using oozie coordinators and workflows which will trigger/execute a java/scala application. Using oozie coordinators, we can automate an application management i.e. application start, stop, schedule and monitor. 

<B> How to use : </B>

1. To create/start the oozie job use this command -> bash startApplication.sh application_coordinator.properties
2. To kill/stop the oozie job use this command -> bash stopApplication.sh
3. Before starting an oozie job, one need to assign the OOZIE_URL like below ->
   
   export OOZIE_URL=http://testserver.pralay.org:11000/oozie

4. There are three files which will be used for oozie job configuration ->

   a) application_coordinator.properties (configuration file of oozie job)
   
   b) application_coordinator.xml (coordinator file for execution frequency of oozie job)
   
   c) application_workflow.xml (workflow file of oozie job)

5. There are five sections in application_coordinator.properties file. 

      Section#1 contains distribution(cloudera/mapr) specific details. 
      
      Section#2 contains location of coordinator and workflow files. 
      
      Section#3 contains library file details. 
      
      Section#4 contains application specific details. 
      
      Section#5 contains timeline of oozie job.
      
   Currently in section#1, cloudera specific details are enabled and mapr specific details are disabled. One can toggle between them as      per their requirements.
   
