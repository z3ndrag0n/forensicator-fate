#!/bin/sh
sudo apt-get install postgresql python-psycopg2
sudo su – postgres –c psql <<EOF
create role webpy;
create database webpy;
grant all on database webpy to webpy;
alter role webpy with login;
EOF
