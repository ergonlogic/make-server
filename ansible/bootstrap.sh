#!/bin/bash

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true
truthy="true 1"

if [[ $truthy =~ $VAGRANT ]]; then
  ANSIBLE_DIR=/vagrant/ansible
else
  ANSIBLE_DIR=./ansible
fi

if [[ $truthy =~ $DRUSH_DEV ]]; then
  curl -sSL https://raw.githubusercontent.com/GetValkyrie/ansible-bootstrap/master/install-ansible.sh | /bin/bash
  ansible-galaxy install -r $ANSIBLE_DIR/requirements.yml -p $ANSIBLE_DIR/roles/ --ignore-errors
  ansible-playbook $ANSIBLE_DIR/drush_dev.yml -i $ANSIBLE_DIR/inventory
else
  echo "Installing Ansible"
  apt-get -y install software-properties-common > /dev/null
  apt-add-repository ppa:ansible/ansible &> /dev/null
  apt-get update > /dev/null
  apt-get -y install ansible > /dev/null
  ansible-galaxy install geerlingguy.mysql -p $ANSIBLE_DIR/roles/ --ignore-errors
  ansible-playbook $ANSIBLE_DIR/drush.yml -i $ANSIBLE_DIR/inventory
fi


