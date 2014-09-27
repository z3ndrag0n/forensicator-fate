#!/bin/sh
# Download and install python library to interact with Elasticsearch
git clone https://github.com/rhec/pyelasticsearch.git
cd pyelasticsearch
python setup.py build
sudo python setup.py install
