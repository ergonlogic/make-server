#!/bin/bash

# Set different project roots depending on Vagrant or TravisCI environments.
if [ -z ${TRAVIS_BUILD_DIR+x} ]; then
  cd /vagrant
  make deps
fi

make init
source ~/.bashrc

make drush

make drupal

make behat

