#!/usr/bin/env bash

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$?

echo ">>> Installing Apache Server"

[[ -z $1 ]] && { echo "!!! IP address not set. Check the Vagrant file."; exit 1; }

if [[ -z $2 ]]; then
    public_folder="/vagrant"
else
    public_folder="$2"
fi

if [[ -z $4 ]]; then
    github_url="https://raw.githubusercontent.com/fideloper/Vaprobash/master"
else
    github_url="$4"
fi

# Add repo for latest FULL stable Apache
# (Required to remove conflicts with PHP PPA due to partial Apache upgrade within it)
sudo add-apt-repository -y ppa:ondrej/apache2


# Update Again
sudo apt-key update
sudo apt-get update

# Install Apache
# -qq implies -y --force-yes
sudo apt-get install -qq apache2 apache2-mpm-event

echo ">>> Configuring Apache"

# Add vagrant user to www-data group
sudo usermod -a -G www-data vagrant

# Apache Config
# On separate lines since some may cause an error
# if not installed
sudo a2dismod mpm_prefork
sudo a2dismod php5
sudo a2enmod mpm_worker rewrite actions ssl
curl --silent -L $github_url/helpers/vhost.sh > vhost
sudo chmod guo+x vhost
sudo mv vhost /usr/local/bin

# Create a virtualhost to start, with SSL certificate
sudo vhost -s $3 -d $public_folder -p /etc/ssl/$3 -c $3 -a $3
sudo a2dissite 000-default

# If PHP is installed or HHVM is installed, proxy PHP requests to it
if [[ $PHP_IS_INSTALLED -eq 0 ]]; then

    # PHP Config for Apache
    sudo a2enmod proxy_fcgi
else
    # vHost script assumes ProxyPassMatch to PHP
    # If PHP is not installed, we'll comment it out
    sudo sed -i "s@ProxyPassMatch@#ProxyPassMatch@" /etc/apache2/sites-available/$3.conf
fi

sudo service apache2 restart
