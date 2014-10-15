#!/bin/sh
sudo apt-get install jenkins
#update Volatility to 2.4
sudo apt-get install python-volatility
sudo chgrp jenkins /ioc /blacklist /whitelist /reverse /artifacts
sudo chmod g+w /ioc /blacklist /whitelist /reverse /artifacts
sudo su - root -c 'echo "%jenkins ALL=(ALL:ALL) NOPASSWD:ALL" >/etc/sudoers.d/jenkins'
sudo chmod 440 /etc/sudoers.d/jenkins
sudo adduser sansforensics jenkins

#from lucabelmondo on github (comment on https://gist.github.com/rowan-m/1026918)
wget -O default.js http://updates.jenkins-ci.org/update-center.json
sed '1d;$d' default.js > default.json
sudo mkdir /var/lib/jenkins/updates
sudo mv default.json /var/lib/jenkins/updates/
sudo chown -R jenkins:jenkins /var/lib/jenkins/updates
sudo service jenkins restart

#update Jenkins
cd /usr/share/jenkins
sudo mv jenkins.war jenkins-last-install.war
sudo curl -o jenkins.war -L http://updates.jenkins-ci.org/download/war/latest/jenkins.war
cd ~
sudo service jenkins restart

#wait for Jenkins to start
until wget http://localhost:8080/ 2>&1 | grep "response" | grep -c "200 OK"; do echo Sleeping 15 seconds waiting for Jenkins to start... ; sleep 15 ; done

#install plugins
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 install-plugin parameterized-trigger
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 install-plugin conditional-buildstep
sudo service jenkins restart

#wait for Jenkins to start
until wget http://localhost:8080/ 2>&1 | grep "response" | grep -c "200 OK"; do echo Sleeping 15 seconds waiting for Jenkins to start... ; sleep 15 ; done

#install jobs
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job bulk_extractor_disk <forensicator-fate/jenkins/jobs/bulk_extractor_disk.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job bulk_extractor_memory <forensicator-fate/jenkins/jobs/bulk_extractor_memory.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job bulk_extractor <forensicator-fate/jenkins/jobs/bulk_extractor.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Carving <forensicator-fate/jenkins/jobs/Carving.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job FStimeline <forensicator-fate/jenkins/jobs/FStimeline.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job IOC <forensicator-fate/jenkins/jobs/IOC.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job NSRL <forensicator-fate/jenkins/jobs/NSRL.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job sorter <forensicator-fate/jenkins/jobs/sorter.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job PlasoExporter <forensicator-fate/jenkins/jobs/PlasoExporter.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Supertimeline <forensicator-fate/jenkins/jobs/Supertimeline.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.0 <forensicator-fate/jenkins/jobs/Volatility.0.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.1 <forensicator-fate/jenkins/jobs/Volatility.1.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.2 <forensicator-fate/jenkins/jobs/Volatility.2.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.3 <forensicator-fate/jenkins/jobs/Volatility.3.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.4 <forensicator-fate/jenkins/jobs/Volatility.4.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.5 <forensicator-fate/jenkins/jobs/Volatility.5.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.6 <forensicator-fate/jenkins/jobs/Volatility.6.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.7 <forensicator-fate/jenkins/jobs/Volatility.7.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility.8 <forensicator-fate/jenkins/jobs/Volatility.8.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job Volatility <forensicator-fate/jenkins/jobs/Volatility.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-job findWindowsEvidence <forensicator-fate/jenkins/jobs/findWindowsEvidence.xml

#install views
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-view "Filesystem Analysis" <forensicator-fate/jenkins/views/FSAnalysis.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-view "Memory Analysis" <forensicator-fate/jenkins/views/MemoryAnalysis.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-view "Helper Tasks" <forensicator-fate/jenkins/views/HelperTasks.xml
java -jar /run/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 create-view "Find Evidence" <forensicator-fate/jenkins/views/ForensicatorFATE.xml

sudo cp forensicator-fate/scripts/guess_profile.pl /usr/bin
sudo chown jenkins:jenkins /usr/bin/guess_profile.pl
sudo chmod 755 /usr/bin/guess_profile.pl
