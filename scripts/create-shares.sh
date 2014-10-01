#!/bin/sh
sudo mkdir /ioc /blacklist /whitelist /reverse /artifacts
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf-default
sudo su - root -c "cat >/etc/samba/smb.conf-fate" <<EOF

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
sudo su - root -c "cat /etc/samba/smb.conf-default /etc/samba/smb.conf-fate >/etc/samba/smb.conf"
sudo service smbd restart
