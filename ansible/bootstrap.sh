#!/bin/bash

which ansible > /dev/null
install_ansible=$?

# Set different project roots depending on Vagrant or TravisCI environments.
if [[ $1 == 'true' ]]; then
  ROOT=/vagrant
  SCRIPT_USER=vagrant
  if [[ $install_ansible == 1 ]]; then
    echo "Installing Ansible"
    sudo apt-get -y install software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible-1.9
    sudo apt-get update -qq
    sudo apt-get -y install -o Dpkg::Options::="--force-confnew" ansible
  fi
else
  ROOT=$TRAVIS_BUILD_DIR
  SCRIPT_USER=travis
  echo "Installing Ansible"
  if [[ $install_ansible == 1 ]]; then
    pip install ansible
  fi
fi

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true
PLAYBOOK_DIR="$ROOT/ansible/plays"

echo "Installing Drush"
ansible-playbook $PLAYBOOK_DIR/drush.yml

echo "Installing Drupal"
ansible-playbook $PLAYBOOK_DIR/drupal.yml --extra-vars="root=$ROOT"

echo "Installing Behat"
ansible-playbook $PLAYBOOK_DIR/behat.yml -e "root=$ROOT"

