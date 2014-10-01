#!/bin/sh
sudo easy_install web.py
sudo apt-get install apache2
sudo apt-get install libapache2-mod-wsgi
sudo a2enmod rewrite

#Now add the following lines to /etc/apache2/sites-available/default, immediately preceding the ErrorLog directive:

WSGIScriptAlias / /var/www/forensicator-fate
Alias /static /var/www/public_html

<Directory /var/www/forensicator-fate>
  SetHandler wsgi-script
  Options ExecCGI FollowSymLinks
</Directory>

AddType text/html .py

<Location />
  RewriteEngine on
  RewriteBase /
  RewriteCond %{REQUEST_URI} !^/static
  RewriteCond %{REQUEST_URI} !^(/.*)+ffate.py/
  RewriteRule ^(.*)$ ffate.py/$1 [PT]
</Location>

sudo mkdir /var/www/forensicator-fate
sudo mkdir /var/www/public_html
sudo mv /var/www/index.html /var/www/public_html
sudo service apache2 restart
