#!/bin/sh

#update Jenkins
cd /usr/share/jenkins
sudo mv jenkins.war jenkins-last-install.war
# need to pin this to 1.575 as this is where jenkins devs (re)broke the cli
sudo curl -o jenkins.war -L http://updates.jenkins-ci.org/download/war/1.575/jenkins.war
cd ~
sudo service jenkins restart

#wait for Jenkins to start
until wget http://localhost:8080/ 2>&1 | grep "response" | grep -c "200 OK"; do echo Sleeping 15 seconds waiting for Jenkins to start... ; sleep 15 ; done
