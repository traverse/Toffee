# -*- mode: ruby -*-
# vi: set ft=ruby :

####
# Config GitHub Settings
##########

github_username = "Traverse"
github_repo     = "Toffee"
github_branch   = "master"
github_url      = "https://raw.githubusercontent.com/#{github_username}/#{github_repo}/#{github_branch}"

####
# VM Configuration
##########

# See https://atlas.hashicorp.com/boxes/search for available boxes.
box      = "ubuntu/trusty64"
box_name = "Toffee"

hostname = "toffee.dev"
hosts    = [ # Array containing all the vhosts for vagrant-hostsupdater.
  # "example1.dev",
  # "example2.dev",
  # "example3.dev",
]

# Set a local private network IP address.
# See http://en.wikipedia.org/wiki/Private_network for explanation
# You can use the following IP ranges:
#   10.0.0.1    - 10.255.255.254
#   172.16.0.1  - 172.31.255.254
#   192.168.0.1 - 192.168.255.254
server_ip     = "192.168.22.10"
server_cpus   = "1"    # Cores
server_memory = "512"  # MB
server_swap   = "1024" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

# See http://en.wikipedia.org/wiki/List_of_tz_database_time_zones for available timezones.
# UTC        for Universal Coordinated Time
# EST        for Eastern Standard Time
# US/Central for American Central
# US/Eastern for American Eastern
server_timezone = "UTC"

####
# Database Configuration
##########

mysql_root_password = "root"  # We'll assume user "root"
mysql_version       = "5.5"   # Options: 5.5 | 5.6
mysql_enable_remote = "false" # remote access enabled when true

####
# Languages and Packages
##########

# Ruby Options

ruby_version = "latest" # Choose what ruby version should be installed (will also be the default version)
ruby_gems    = [ # List any Ruby Gems that you want to install
  #"jekyll",
  #"sass",
  #"compass",
  #"susy",
  #"breakpoint",
]

# PHP Options

php_timezone      = "UTC" # http://php.net/manual/en/timezones.php
php_version       = "5.6" # Options: 5.5 | 5.6
composer_packages = [ # List any global Composer packages that you want to install
  #"phpunit/phpunit:4.7.*",
  #"codeception/codeception:2.0.*",
  #"phpspec/phpspec:2.2.*",
  #"squizlabs/php_codesniffer:2.3.*",
  #"halleck45/phpmetrics:1.1.*",
  #"pdepend/pdepend:2.1.*",
  #"phpmd/phpmd:2.2.*",
  #"sebastian/phpcpd:2.0.*",
  #"sebastian/phpdcd:1.0.*",
]

# NodeJS Options

nodejs_version  = "latest" # By default "latest" will equal the latest stable version
nodejs_packages = [ # List any global NodeJS packages that you want to install
  #"grunt",
  #"grunt-cli",
  #"gulp",
  #"bower",
  #"yo",
]

# The synced folder settings.
src  = "."
dest = "/var/www"
id   = "core"

Vagrant.configure("2") do |config|

  # Set server to configured box.
  config.vm.box = box

  # Create a hostname, don't forget to put it to the `hosts` file
  # This will point to the server's default virtual host
  config.vm.hostname = hostname

  # Create a static IP
  config.vm.network :private_network, ip: server_ip
  config.vm.network :forwarded_port, guest: 80, host: 8000

  # Use NFS for the shared folder
  config.vm.synced_folder src, dest,
    id: id

  # If using VirtualBox
  config.vm.provider :virtualbox do |vb|

    vb.name = box_name

    # Set server cpus
    vb.customize ["modifyvm", :id, "--cpus", server_cpus]

    # Set server memory
    vb.customize ["modifyvm", :id, "--memory", server_memory]

    # Set the timesync threshold to 10 seconds, instead of the default 20 minutes.
    # If the clock gets more than 15 minutes out of sync (due to your laptop going
    # to sleep for instance, then some 3rd party services will reject requests.
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]

  end

  if Vagrant.has_plugin?("vagrant-hostsupdater")
    config.hostsupdater.aliases = hosts
  end

  ####
  # Base Items
  ##########

  # Provision Base Packages
  # config.vm.provision "shell", path: "#{github_url}/scripts/base.sh", args: [github_url, server_swap, server_timezone]

  # optimize base box
  # config.vm.provision "shell", path: "#{github_url}/scripts/base_box_optimizations.sh", privileged: true

  # Provision PHP
  # config.vm.provision "shell", path: "#{github_url}/scripts/php.sh", args: [php_timezone, php_version]

  # Provision Vim
  # config.vm.provision "shell", path: "#{github_url}/scripts/vim.sh", args: github_url

  ####
  # Web Servers
  ##########

  # Provision Apache Base
  # config.vm.provision "shell", path: "#{github_url}/scripts/apache.sh", args: [server_ip, dest, hostname, github_url]

  ####
  # Databases
  ##########

  # Provision MySQL
  # config.vm.provision "shell", path: "#{github_url}/scripts/mysql.sh", args: [mysql_root_password, mysql_version, mysql_enable_remote]

  ####
  # In-Memory Stores
  ##########

  # Install Memcached
  # config.vm.provision "shell", path: "#{github_url}/scripts/memcached.sh"

  ####
  # Additional Languages
  ##########

  # Install Nodejs
  # config.vm.provision "shell", path: "#{github_url}/scripts/nodejs.sh", privileged: false, args: nodejs_packages.unshift(nodejs_version, github_url)

  # Install Ruby Version Manager (RVM)
  # config.vm.provision "shell", path: "#{github_url}/scripts/rvm.sh", privileged: false, args: ruby_gems.unshift(ruby_version)

  ####
  # Frameworks and Tooling
  ##########

  # Provision Composer
  # config.vm.provision "shell", path: "#{github_url}/scripts/composer.sh", privileged: false, args: composer_packages.join(" ")

  # Install phpMyAdmin
  # config.vm.provision "shell", path: "#{github_url}/scripts/phpmyadmin.sh", args: mysql_root_password

  # Install Screen
  # config.vm.provision "shell", path: "#{github_url}/scripts/screen.sh"

  # Install Mailcatcher
  # config.vm.provision "shell", path: "#{github_url}/scripts/mailcatcher.sh"

  # Install git-ftp
  # config.vm.provision "shell", path: "#{github_url}/scripts/git-ftp.sh", privileged: false

  ####
  # Local Scripts
  # Any local scripts you may want to run post-provisioning.
  # Add these to the same directory as the Vagrantfile.
  ##########
  # config.vm.provision "shell", path: "./script.sh"

end
