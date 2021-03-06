SHELL        := /bin/bash
project_root ?= /vagrant
bin_dir       = ~/.bin
src_dir       = ~/.src
drush_dir     = ~/.drush
drush         = $(bin_dir)/drush

up:
	@vagrant up
rebuild:
	@vagrant destroy -f && vagrant up
make:
	@vagrant ssh -c"cd /var/www/html/d8 && sudo drush -y make /vagrant/dev.build.yml"
test:
	@vagrant ssh -c"cd /vagrant && source behat_params.sh && bin/behat"
wip:
	@vagrant ssh -c"cd /vagrant && source behat_params.sh && bin/behat --tags=wip"
test-on-travis:
	source behat_params.sh && bin/behat

include .mk/*.mk

