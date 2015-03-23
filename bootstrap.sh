#!/bin/bash

PASSWORD="vagrant"

# Start updating out of date things.
sudo apt-get update 2> /dev/null

# Install vim editor.
sudo apt-get install -y vim 2> /dev/null

# Start preparing PHP installation.
sudo apt-get install python-software-properties build-essential -y 2> /dev/null
sudo add-apt-repository ppa:ondrej/php5 -y 2> /dev/null
sudo apt-get update 2> /dev/null

# Install PHP.
sudo apt-get install php5-common php5-dev php5-cli php5-fpm -y 2> /dev/null

# Install PHP extensions.
sudo apt-get install curl php5-curl php5-gd php5-mcrypt php5-mysql -y 2> /dev/null

# Install Apache2 server.
sudo apt-get install -y apache2 2> /dev/null
sudo apt-get install -y libapache2-mod-php5 2> /dev/null

# Prepare for MySQL installation.
sudo apt-get install debconf-utils -y 2> /dev/null
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"

# Install MySQL.
sudo apt-get install mysql-server -y 2> /dev/null

# Prepare for PHPMyAdmin installation.
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"

# Install PHPMyAdmin.
sudo apt-get -y install phpmyadmin 2> /dev/null

# Setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html"
    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# Enable Apache mod_rewrite.
sudo a2enmod rewrite 2> /dev/null

# Restart the Apache2 server.
sudo service apache2 reload 2> /dev/null

# Create a MySQL database.
mysql -uroot -p$PASSWORD -e "CREATE DATABASE vagrant_db DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci"
