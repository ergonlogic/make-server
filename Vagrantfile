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
      path: "https://raw.githubusercontent.com/GetValkyrie/ansible-bootstrap/master/install-ansible.sh"
    d.vm.provision "shell",
      inline: "ansible-galaxy install -r /vagrant/ansible/requirements.yml -p /vagrant/ansible/roles/ --ignore-errors"
    d.vm.provision "shell",
      inline: "PYTHONUNBUFFERED=1 ANSIBLE_FORCE_COLOR=true ansible-playbook /vagrant/ansible/site.yml -i /vagrant/ansible/inventory",
      keep_color: true

  end
end
