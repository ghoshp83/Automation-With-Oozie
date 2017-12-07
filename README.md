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
   
   In section#4, unit of coordinatorFrequency is in minutes.
   
   All the dependent libraries(of section#3) are present in dependencies folder in this repository
   
 6. application_coordinator.xml file will contain the scheduling details. It will take coordination frequency from
    application_coordinator.properties file. This file will also refer to the calling application.
    
7. application_workflow.xml file will have workflow logics. We can have reference of multiple application along with calling
   application.
   
8. Sample oozie commands are below ->
   oozie jobs -jobtype coordinator [to check what all jobs are running]
   oozie job -config <location_of_properties_file> –run [to start a oozie job]
   oozie job -info <JOBID> [to see details of a job]
   oozie job -kill <JOBID> [to kill a job]
   oozie job -log <JOBID> [to check the log details of a job]   


