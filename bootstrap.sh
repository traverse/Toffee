#!/bin/bash

# Variables used for configuration.
PASSWORD="vagrant"
DATABASE="vagrant_db"
ERROR_LEVEL="E_ALL & E_STRICT & E_DEPRECATED"

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

# Install Xdebug.
mkdir /var/log/xdebug
chown www-data:www-data /var/log/xdebug
sudo pecl install xdebug

# Install Apache2 server.
sudo apt-get install -y apache2 2> /dev/null
sudo apt-get install -y libapache2-mod-php5 2> /dev/null

# Enable Apache mod_rewrite.
sudo a2enmod rewrite 2> /dev/null

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

# Edit php.ini to enable error reporting.
sed -i "s/error_reporting = .*/error_reporting = $ERROR_LEVEL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

# Edit php.ini to enable Xdebug.
cat << EOF | sudo tee -a /etc/php5/apache2/php.ini

;;;;;;;;;;;;;;;;;;;;;;;;;;
;         Xdebug         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;

zend_extension = "$(find / -name "xdebug.so" 2> /dev/null)"
xdebug.default_enable = 1
xdebug.scream = 1

EOF

# Setup hosts file.
cat << EOF | sudo tee /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    DocumentRoot "/var/www/html"
    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Restart the Apache2 server.
sudo service apache2 reload 2> /dev/null

# Create a MySQL database.
mysql -uroot -p$PASSWORD -e "CREATE DATABASE $DATABASE DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci"
