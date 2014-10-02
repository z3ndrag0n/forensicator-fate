#!/bin/sh
sudo apt-get install postgresql python-psycopg2
sudo service postgresql start
sudo su - postgres -c psql <<EOF
create role webpy;
create database webpy;
grant all on database webpy to webpy;
alter role webpy with login;
EOF
sudo ed /etc/postgresql/9.1/main/pg_hba.conf <<EOF
/^local.*peer$
s/peer/trust/
w
q
EOF
sudo service postgresql restart
psql -U webpy -d webpy <<EOF
create table cases (id SERIAL, casename varchar, memory_image varchar, disk_image varchar, disk_name varchar, timezone varchar, volatility_profile varchar, notes varchar, keywords varchar);
\q
EOF
