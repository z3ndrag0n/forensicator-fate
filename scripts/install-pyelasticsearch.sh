#!/bin/sh
# Make sure plaso is up-to-date before continuing (thanks BMG)
sudo apt-get update
sudo apt-get install python-plaso
# Download and install python library to interact with Elasticsearch
git clone https://github.com/rhec/pyelasticsearch.git
cd pyelasticsearch
python setup.py build
sudo python setup.py install
