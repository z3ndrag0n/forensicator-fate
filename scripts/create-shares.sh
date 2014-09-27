#!/bin/sh
sudo mkdir /ioc /blacklist /whitelist /reverse /artifacts
sudo echo >> /etc/samba/smb.conf <<EOF
[ioc]
	path = /ioc
	writeable = yes
	browseable = yes
	guest ok = yes

[blacklist]
	path = /blacklist
	writeable = yes
	browseable = yes
	guest ok = yes

[whitelist]
	path = /whitelist
	writeable = yes
	browseable = yes
	guest ok = yes

[reverse]
	path = /reverse
	writeable = yes
	browseable = yes
	guest ok = yes

[artifacts]
	path = /artifacts
	writeable = yes
	browseable = yes
	guest ok = yes
EOF
sudo service smbd restart
