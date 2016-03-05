# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.define 'drush' do |d|
    d.vm.box = "ubuntu/trusty64"
    d.vm.provider "virtualbox" do |v|
      v.memory = 1024
      v.cpus = 2
    end

    d.vm.hostname = 'drush.local'
    d.vm.network 'private_network', ip: '10.57.57.57'

    d.vm.provision "shell",
      path: "ansible/bootstrap.sh",
      env: { :DRUSH_DEV => ENV['DRUSH_DEV'] || "false", :VAGRANT => "true" },
      keep_color: true
  end
end
