#!/bin/bash

if [[ $USER = "root" ]]; then
    echo "You're running this script as root. Bad things will happen."
    echo "I'll su to sansforensics and run again now."
    su - sansforensics -c "forensicator-fate/scripts/ffate-bundle-installer.sh"
elif [[ $USER = "sansforensics" ]]; then
echo "The SANS Gold Paper says to run me, then set up your ELK VM and manually"
echo "setup the kibana dash. However, if you are willing to set up your ELK"
echo "VM first, I'll automagically setup Kibana for you. Go ahead (I'll wait)..."
echo "Please enter your ELK IP address,which is displayed"
echo -n "on the console of the VM: "
read ELK_IP

cd ~
forensicator-fate/scripts/install-pyelasticsearch.sh ${ELK_IP}
forensicator-fate/scripts/create-shares.sh
forensicator-fate/scripts/install-jenkins.sh
forensicator-fate/scripts/install-pg.sh ${ELK_IP}
forensicator-fate/scripts/install-ffate.sh
cp forensicator-fate/ffate.pdf Desktop/
else
echo "You started this script as neither sansforensics (correct), nor root"
echo "(incorrect, but understandable). I can't guess your intention. Giving up."
fi