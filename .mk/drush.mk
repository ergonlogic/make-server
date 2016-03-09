drush_src    = $(src_dir)/drush-source
release      = stable

help-drush:
	@echo "make drush"
	@echo "  Install Drush."
	@echo "make drush release=<release>"
	@echo "  Install a specific release of Drush. Defaults to '$(release)'. Valid options include: stable, unstable and source."

clean-drush: vm
	@rm -f $(drush)

deps-drush: vagrant mysql-server aptitude-update
	@echo Installing Drush dependencies
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install git php5-mysql php5-cli php5-gd

drush: drush-$(release)
	@echo Installing the $(release) release of Drush.
	@chmod a+x $(drush)
	@$(drush) --version

drush-stable: vm init clean-drush
	@curl -SsL -z $(src_dir)/$@.phar -o $(src_dir)/$@.phar http://files.drush.org/drush.phar
	@ln -s $(src_dir)/$@.phar $(drush)

drush-unstable: vm init clean-drush
	@curl -SsL -z $(src_dir)/$@.phar -o $(src_dir)/$@.phar http://files.drush.org/drush-unstable.phar
	@ln -s $(src_dir)/$@.phar $(drush)

drush-source: vm init clean-drush composer
	@if ! [ -d $(drush_src) ]; then git clone https://github.com/drush-ops/drush.git $(drush_src); fi
	@cd $(drush_src); git fetch
	@cd $(drush_src); git checkout $(branch)
	@cd $(drush_src); composer install --prefer-source
	@ln -s $(drush_src)/drush $(drush)
	@echo " Drush git branch:" `cd $(drush_src); git rev-parse --abbrev-ref HEAD`

