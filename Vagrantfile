# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "puppetlabs/centos-6.6-64-puppet"

  config.vm.define "zone5" do |host|
    host.vm.network "private_network", ip: "192.168.33.11"
    host.vm.hostname = 'zone5.local'
    host.vm.provision "shell", path: "zone5.sh"
  end

  config.vm.define "internal" do |host|
    host.vm.network "private_network", ip: "192.168.33.10"
    host.vm.hostname = 'internal.local'
    host.vm.provision "shell", path: "internal.sh"
    host.vm.network "forwarded_port", guest: 8500, host: 8500
  end

  config.vm.define "zone2" do |host|
    host.vm.network "private_network", ip: "192.168.33.12"
    host.vm.hostname = 'zone2.local'
    host.vm.provision "shell", path: "zone2.sh"
  end
end
