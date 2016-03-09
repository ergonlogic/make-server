selenium         = $(bin_dir)/selenium-server.jar
selenium_version = 2.52
selenium_release = $(selenium-version).0

help-behat:
	@echo "make behat"
	@echo "  Install Behat."
	@echo "make selenium"
	@echo "  Install Selenium."

deps-selenium: vagrant aptitude-update
	@echo Installing Selenium dependencies
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install openjdk-7-jre-headless

selenium: vm
	@curl -sSL -z $(selenium) -o $(selenium) http://selenium-release.storage.googleapis.com/$(selenium-version)/selenium-server-standalone-$(selenium-release).jar

drush-bde-env: vm init $(bin_dir)/drush drupal
	@git clone https://github.com/pfrenssen/drush-bde-env.git ~/.drush/drush-bde-env
	@$(drush) cc drush
	@cd $(project_root) && $(drush) beg --subcontexts=profiles/$(profile)/modules --site-root=$(root) --skip-path-check --base-url=$(uri) $(project_root)/behat_params.sh

deps-behat: vagrant aptitude-update composer
	@echo Installing Behat dependencies
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install php5-curl

behat: vm
ifeq '$(project_root)' '/vagrant'
	cd $(project_root) && $(composer) install
else
	cd $(project_root) && composer install
endif
