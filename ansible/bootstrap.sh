#!/bin/bash

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true

# Isolate differences between Vagrant and TravisCI environments.
if [[ $2 == 'true' ]]; then
  ANSIBLE_DIR=/vagrant/ansible
  ROOT=/vagrant
else
  ANSIBLE_DIR=./ansible
  ROOT=../..
fi

# Default to packaged versions of Ansible and Drush, but allow installation
# from source.
if [[ $1 == 'true' ]]; then
  curl -sSL https://raw.githubusercontent.com/GetValkyrie/ansible-bootstrap/master/install-ansible.sh | /bin/bash
  ansible-galaxy install -r $ANSIBLE_DIR/requirements.yml -p $ANSIBLE_DIR/roles/ --ignore-errors
  ansible-playbook $ANSIBLE_DIR/plays/drush_dev.yml -i $ANSIBLE_DIR/hosts -e "root=$ROOT"
else
  echo "Installing Ansible"
  apt-get -y install software-properties-common > /dev/null
  apt-add-repository -y ppa:ansible/ansible-1.9 &> /dev/null
  apt-get update -qq > /dev/null
  apt-get -y install -o Dpkg::Options::="--force-confnew" ansible > /dev/null
  echo "Installing Drush"
  ansible-playbook $ANSIBLE_DIR/plays/drush.yml -i $ANSIBLE_DIR/hosts -e "root=$ROOT"
fi

echo "Installing Drupal"
ansible-playbook $ANSIBLE_DIR/plays/drupal.yml -i $ANSIBLE_DIR/hosts -e "root=$ROOT"

