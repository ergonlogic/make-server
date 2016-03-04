#!/bin/bash

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true

truthy="true 1"
if [[ $truthy =~ $1 ]]; then
  curl -sSL https://raw.githubusercontent.com/GetValkyrie/ansible-bootstrap/master/install-ansible.sh | /bin/bash
  ansible-galaxy install -r /vagrant/ansible/requirements.yml -p /vagrant/ansible/roles/ --ignore-errors
  ansible-playbook /vagrant/ansible/drush_dev.yml -i /vagrant/ansible/inventory
else
  apt-get install software-properties-common
  apt-add-repository ppa:ansible/ansible
  apt-get update
  apt-get install ansible
  ansible-galaxy install geerlingguy.mysql -p /vagrant/ansible/roles/ --ignore-errors
  ansible-playbook /vagrant/ansible/drush.yml -i /vagrant/ansible/inventory
fi


