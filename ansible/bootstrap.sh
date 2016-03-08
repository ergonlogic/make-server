#!/bin/bash

which ansible > /dev/null
install_ansible=$?
if [[ $install_ansible == 1 ]]; then
  echo "Installing Ansible"
  sudo apt-get -y install software-properties-common
  sudo apt-add-repository -y ppa:ansible/ansible
  sudo apt-get update -qq
  sudo apt-get -y install -o Dpkg::Options::="--force-confnew" ansible
fi

# Set different project roots depending on Vagrant or TravisCI environments.
if [[ $1 == 'true' ]]; then
  ROOT=/vagrant
  SCRIPT_USER=vagrant
else
  ROOT=$TRAVIS_BUILD_DIR
  SCRIPT_USER=travis
fi

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true
PLAYBOOK_DIR="$ROOT/ansible/plays"

echo "Installing Drush"
ansible-playbook $PLAYBOOK_DIR/drush.yml -i $ROOT/ansible/hosts

echo "Installing Drupal"
ansible-playbook $PLAYBOOK_DIR/drupal.yml -i $ROOT/ansible/hosts -e "root=$ROOT"

echo "Installing Behat"
ansible-playbook $PLAYBOOK_DIR/behat.yml -i $ROOT/ansible/hosts -e "root=$ROOT"

