#!/bin/sh

#update jobs
cd forensicator-fate/jenkins/jobs
for job in `ls -1 | sed 's/\.xml//'`; do echo Updating job $job; java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 update-job $job <${job}.xml; done

cd ~
sudo cp forensicator-fate/scripts/guess_profile.pl /usr/bin
sudo chown jenkins:jenkins /usr/bin/guess_profile.pl
sudo chmod 755 /usr/bin/guess_profile.pl
