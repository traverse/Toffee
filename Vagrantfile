# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables used for configuration. Please don't change them unless you
# know what you're doing.

# The Vagrantfile API version to use.
VAGRANTFILE_API_VERSION = "2"

# Which box Vagrant should use.
box = "ubuntu/trusty64"

# Amount of RAM available to VM.
memory = 1024

# Amount of CPUs available to VM.
cpu = 2

# The name of the project.
project_name = "projectname"

# The IP adress used by the VM.
ip_address = "192.168.9.99"

# The adress on which the VM will be available in your browser.
hostname = project_name+".dev"

# The Vagrant SSH username.
username = "vagrant"

# The Vagrant SSH password.
password = "vagrant"

# All Vagrant configuration is done below. Please don't change it unless you
# know what you're doing.

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = box

  # Setting the username and password for SSH.
  config.ssh.username = username
  config.ssh.password = password

  # Assigning IP adress to the VM.
  config.vm.network :private_network, ip: ip_address

  # Set the project's hostname.
  config.vm.hostname = hostname

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine.

  # Mapping the port used by Apache.
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Mapping the port used by MySQL.
  config.vm.network "forwarded_port", guest: 3306, host: 8081

  # Share additional folders to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder ".", "/vagrant",
    id: "vagrant-root",
    owner: "vagrant",
    group: "vagrant"

  config.vm.synced_folder "./html", "/var/www/html
  ",
    create: true,
    id: "web-root",
    owner: "www-data",
    group: "www-data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  config.vm.provider :virtualbox do |vb|

    # Set the VirtualBox name when booting the machine.
    vb.name = project_name

    # Display the VirtualBox GUI when booting the machine
    vb.gui = false

    # Customize the amount of RAM and CPUs on the VirtualBox machine.
    vb.customize ["modifyvm", :id, "--memory", memory, "--cpus", cpu]

  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.

  config.vm.provision :shell, :path => "bootstrap.sh"

end
