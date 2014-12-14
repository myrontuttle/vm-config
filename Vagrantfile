# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	# Every Vagrant virtual environment requires a box to build off of.
	config.vm.box = "myrontuttle/trusty"

	# For masterless, mount your salt file root
    config.vm.synced_folder "salt/", "/srv/salt/"
    config.vm.synced_folder "formulas/", "/srv/formulas/"
    config.vm.synced_folder "pillar/", "/srv/pillar/"

	# Provision with Salt (first remove minion_id to replace with hostname)
	config.vm.provision "shell", inline: "rm -f /etc/salt/minion_id"
	config.vm.provision :salt do |salt|
		salt.minion_config = "minion"
		salt.run_highstate = true
	end

	# Version Control Minion
	#config.vm.define "vcs" do |vcs|
		# Configure Networking
	#	vcs.vm.network :private_network, ip: "192.168.50.5"
	#	vcs.vm.network :forwarded_port, guest: 5000, host: 5000
	#	vcs.vm.network :forwarded_port, guest: 80, host: 4567
#
#		vcs.vm.hostname = "vcs01"
#	end
	
	# Continuous Integration Minion
	config.vm.define "ci" do |ci|
		# Configure Networking
		ci.vm.network :private_network, ip: "192.168.50.6"
		ci.vm.network :forwarded_port, guest: 8080, host: 4568
		
		ci.vm.hostname = "ci01"
	end
end
