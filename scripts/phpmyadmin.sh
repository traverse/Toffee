#!/usr/bin/env bash

echo ">>> Installing phpMyAdmin"

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

# Test if Apache is installed
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

if [[ $PHP_IS_INSTALLED -ne 0 ]]; then
  echo "!!! PHP is not installed. Check the Vagrant file."; exit
fi

if [[ $APACHE_IS_INSTALLED -ne 0 ]]; then
  echo "!!! Apache is not installed. Check the Vagrant file."; exit
fi

# Add repo for phpMyAdmin
sudo add-apt-repository -y ppa:nijel/phpmyadmin

# Update Again
sudo apt-get update

# Install PHPMyAdmin without password prompt
# Set password to 'root'
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $1"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $1"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $1"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"


# Install PHPMyAdmin.
sudo apt-get install -qq phpmyadmin

# Add php-fcgi config to phpMyAdmin 'apache.conf'
cat << EOF | sudo tee -a $(find /etc/phpmyadmin -name apache.conf)

ProxyPassMatch ^/phpmyadmin(.*\.php)$ fcgi://127.0.0.1:9000/usr/share/phpmyadmin/\$1
ProxyPassMatch ^/phpmyadmin(.*/)$ fcgi://127.0.0.1:9000/usr/share/phpmyadmin/\$1index.php

EOF

sudo service apache2 restart
