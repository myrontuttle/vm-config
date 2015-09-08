# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	# Every Vagrant virtual environment requires a box to build off of.
	config.vm.box = "myrontuttle/trusty"

	# For masterless, mount salt file root
    config.vm.synced_folder "salt/", "/srv/salt/"
    config.vm.synced_folder "formulas/", "/srv/formulas/"
    config.vm.synced_folder "pillar/", "/srv/pillar/"
	config.vm.synced_folder "backups/", "/var/backups/"

	# Provision with Salt (first remove minion_id to replace with hostname)
	config.vm.provision "shell", inline: "rm -f /etc/salt/minion_id"
	config.vm.provision :salt do |salt|
		salt.minion_config = "minion"
		salt.run_highstate = true
	end

	# Version Control Minion
	config.vm.define "vc" do |vc|
		vc.vm.network :private_network, ip: "192.168.50.5"
		vc.vm.hostname = "vc01"
	end
	
	# Continuous Integration Minion
	config.vm.define "ci" do |ci|
		ci.vm.network :private_network, ip: "192.168.50.6"		
		ci.vm.hostname = "ci01"
	end
	
	# Binary Repository Minion
	config.vm.define "br" do |br|
		br.vm.network :private_network, ip: "192.168.50.7"
		br.vm.hostname = "br01"
	end
	
	# Development Minion
	config.vm.define "dev" do |dev|
		dev.vm.network :private_network, ip: "192.168.50.8"		
		dev.vm.hostname = "dev01"
	end
	
	# Tomcat Minion
	config.vm.define "tomcat" do |tomcat|
		tomcat.vm.network :private_network, ip: "192.168.50.9"
		tomcat.vm.hostname = "tomcat01"
	end
	
	# MySQL Minion
	config.vm.define "mysql" do |mysql|
		mysql.vm.network :private_network, ip: "192.168.50.10"		
		mysql.vm.hostname = "mysql01"
	end
	
	# TestApp Minion
	config.vm.define "testapp" do |testapp|
		testapp.vm.network :private_network, ip: "192.168.50.11"
		testapp.vm.hostname = "testapp01"
		testapp.vm.synced_folder "synced/testapp/webapps", "/var/lib/tomcat7/webapps"
	end
end
