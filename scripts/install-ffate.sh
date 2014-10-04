#!/bin/sh
sudo easy_install web.py
sudo apt-get install apache2
sudo apt-get install libapache2-mod-wsgi
sudo a2enmod rewrite wsgi

sudo service apache2 restart

sudo ed /etc/apache2/sites-available/default <<EOF
/ErrorLog
i
WSGIScriptAlias /ffate /var/www/forensicator-fate/ffate.py
Alias /static /var/www/public_html

<Directory /var/www/forensicator-fate>
  SetHandler wsgi-script
  Options ExecCGI FollowSymLinks
</Directory>

AddType text/html .py

<Location />
#  RewriteEngine on
#  RewriteBase /
#  RewriteCond %{REQUEST_URI} !^/static
#  RewriteCond %{REQUEST_URI} !^(/.*)+ffate.py/
#  RewriteRule ^(.*)$ ffate.py/$1 [PT]
</Location>
.
w
q
EOF

wget http://code.jquery.com/jquery-1.11.1.min.js
wget http://jqueryui.com/resources/download/jquery-ui-1.11.1.zip
unzip jquery-ui-1.11.1.zip
wget http://jqueryui.com/resources/download/jquery-ui-themes-1.11.1.zip
unzip jquery-ui-themes-1.11.1.zip

sudo mkdir /var/www/forensicator-fate
sudo mkdir /var/www/public_html
sudo mv /var/www/index.html /var/www/public_html

sudo mv jquery-1.11.1.min.js /var/www/public_html/jquery.js
sudo mv jquery-ui-1.11.1/jquery-ui.min.js /var/www/public_html/jquery-ui.js
sudo mv jquery-ui-1.11.1/jquery-ui.theme.min.css /var/www/public_html/jquery-ui.theme.css
sudo mv jquery-ui-1.11.1/jquery-ui.min.css /var/www/public_html/jquery-ui.css
sudo mv jquery-ui-1.11.1/jquery-ui.structure.min.css /var/www/public_html/jquery-ui.structure.css
sudo mv jquery-ui-1.11.1/images/ /var/www/public_html/
sudo mv jquery-ui-themes-1.11.1/themes/ /var/www/public_html/

sudo cp forensicator-fate/webapp/ffate.css /var/www/public_html/
sudo cp forensicator-fate/webapp/ffate.py /var/www/forensicator-fate/
sudo cp -R forensicator-fate/webapp/templates /var/www/templates

sudo service apache2 restart
