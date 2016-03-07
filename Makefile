up:
	@vagrant up
rebuild:
	@vagrant destroy -f && vagrant up
make:
	@vagrant ssh -c"cd /var/www/html/d8 && sudo drush -y make /vagrant/dev.build.yml"
test:
	@vagrant ssh -c"cd /vagrant && source behat_params.sh && bin/behat"

