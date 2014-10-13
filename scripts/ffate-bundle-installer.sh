#!/bin/sh

echo "The SANS Gold Paper says to run me, then set up your ELK VM and manually"
echo "setup the kibana dash. However, if you are willing to set up your ELK"
echo "VM first, I'll automagically setup Kibana for you. Go ahead (I'll wait)..."
echo "Please enter your ELK IP address,which is displayed"
echo -n "on the console of the VM: "
read ELK_IP

forensicator-fate/scripts/install-pyelasticsearch.sh ${ELK_IP}
forensicator-fate/scripts/create-shares.sh
forensicator-fate/scripts/install-jenkins.sh
forensicator-fate/scripts/install-pg.sh ${ELK_IP}
forensicator-fate/scripts/install-ffate.sh
