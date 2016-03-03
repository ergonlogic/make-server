#!/bin/bash

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true

which ansible > /dev/null
if [ $? -ne 0 ]; then
  curl https://raw.githubusercontent.com/GetValkyrie/ansible-bootstrap/master/install-ansible.sh | /bin/bash
fi

truthy="true 1"
if [[ $truthy =~ $1 ]]; then
  ansible-galaxy install -r /vagrant/ansible/requirements.yml -p /vagrant/ansible/roles/ --ignore-errors
  ansible-playbook /vagrant/ansible/drush_dev.yml -i /vagrant/ansible/inventory
else
  ansible-galaxy install geerlingguy.mysql -p /vagrant/ansible/roles/ --ignore-errors
  ansible-playbook /vagrant/ansible/drush.yml -i /vagrant/ansible/inventory
fi


