#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

 config.vm.box = "debian-wheezy-amd64-puppetlabs"
 config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box"
 
 config.vm.provider "virtualbox" do |v|
   v.gui = true	
   v.memory = 1024
   v.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
 end

 config.librarian_puppet.puppetfile_dir = "puppet"
 config.librarian_puppet.placeholder_filename = ".MYPLACEHOLDER"
 config.vm.provision :shell, :path => "shell/main.sh"

 config.vm.define "atdd-training-vm" do |atddtraining|
   atddtraining.vm.network "private_network", ip: "33.33.33.50"
   atddtraining.vm.provision "puppet"
 end

end
