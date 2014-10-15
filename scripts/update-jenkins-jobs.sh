#!/bin/sh

#update jobs
for job in `ls -1 forensicator-fate/jenkins/jobs`; do echo Updating job $job; java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job $job <${job}.xml; done
