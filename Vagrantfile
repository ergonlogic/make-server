# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.define 'make-server' do |d|
    d.vm.box = "ubuntu/trusty64"
    d.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end

    d.vm.hostname = 'make.local'
    d.vm.network 'private_network', ip: '10.57.57.57'
    config.vm.network "forwarded_port", guest: 8080, host: 8888

    d.vm.provision "shell",
      path: "ansible/bootstrap.sh",
      args: [ ENV['DRUSH_DEV'] || "false", "true" ],
      keep_color: true
  end
end
