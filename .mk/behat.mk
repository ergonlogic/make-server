selenium         = $(bin_dir)/selenium-server.jar
selenium_version = 2.52
selenium_release = $(selenium-version).0
bde_dir          = $(drush_dir)/drush-bde-env
bde_exists       = $(shell if [[ -d $(bde_dir) ]]; then echo 1; fi)

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

drush-bde-env: vm $(root)
	@echo Generating project-specific Behat config
ifneq '$(bde_exists)' '1'
	@git clone https://github.com/pfrenssen/drush-bde-env.git $(bde_dir)
	@$(drush) cc drush
endif
	@cd $(root) && $(drush) beg --subcontexts=profiles/$(profile)/modules --site-root=$(root) --skip-path-check --base-url=$(uri) $(project_root)/behat_params.sh

deps-behat: vagrant aptitude-update composer
	@echo Installing Behat dependencies
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install php5-curl

behat: vm drush-bde-env
ifeq '$(project_root)' '/vagrant'
	@cd $(project_root) && $(composer) install
else
	@cd $(project_root) && composer install
endif
