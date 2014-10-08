#!/bin/sh

cd ~/forensicator-fate
git pull
sudo cp webapp/ffate.py /var/www/forensicator-fate/
sudo cp webapp/templates/* /var/www/templates
sudo cp webapp/ffate.css /var/www/public_html/
