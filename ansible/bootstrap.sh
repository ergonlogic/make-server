#!/bin/bash

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true

# Set different project roots depending on Vagrant or TravisCI environments.
if [[ $2 == 'true' ]]; then
  ROOT=/vagrant
  VAGRANT=true
else
  ROOT=$TRAVIS_BUILD_DIR
  VAGRANT=false
fi
ANSIBLE_DIR=$ROOT/ansible

# Default to packaged versions of Ansible and Drush, but allow installation
# from source.
if [[ $1 == 'true' ]]; then
  curl -sSL https://raw.githubusercontent.com/GetValkyrie/ansible-bootstrap/master/install-ansible.sh | /bin/bash
  ansible-galaxy install -r $ANSIBLE_DIR/requirements.yml -p $ANSIBLE_DIR/roles/ --ignore-errors
  ansible-playbook $ANSIBLE_DIR/plays/drush_dev.yml -i $ANSIBLE_DIR/hosts -e "root=$ROOT" -e "vagrant=$VAGRANT"
else
  echo "Installing Ansible"
  apt-get -y install software-properties-common > /dev/null
  apt-add-repository -y ppa:ansible/ansible-1.9 &> /dev/null
  apt-get update -qq > /dev/null
  apt-get -y install -o Dpkg::Options::="--force-confnew" ansible > /dev/null
  echo "Installing Drush"
  ansible-playbook $ANSIBLE_DIR/plays/drush.yml -i $ANSIBLE_DIR/hosts -e "root=$ROOT" -e "vagrant=$VAGRANT"
fi

echo "Installing Drupal"
ansible-playbook $ANSIBLE_DIR/plays/drupal.yml -i $ANSIBLE_DIR/hosts -e "root=$ROOT" -e "vagrant=$VAGRANT"

echo "Installing Behat"
ansible-playbook $ANSIBLE_DIR/plays/behat.yml -i $ANSIBLE_DIR/hosts -e "root=$ROOT" -e "vagrant=$VAGRANT"
