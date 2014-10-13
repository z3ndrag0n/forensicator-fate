#!/bin/sh
# Make sure plaso is up-to-date before continuing (thanks BMG)
sudo apt-get update
sudo apt-get install python-plaso
# Download and install python library to interact with Elasticsearch
git clone https://github.com/rhec/pyelasticsearch.git
cd pyelasticsearch
python setup.py build
sudo python setup.py install
cd ~
wget https://plaso.googlecode.com/git/extra/plaso_kibana_example.json
scp plaso_kibana_example.json ls_user@$1:
ssh ls_user@$1 sudo cp plaso_kibana_example.json /opt/logstash/vendor/kibana/app/dashboards/plaso.json
