project_root = $(shell if [ -z ${TRAVIS_BUILD_DIR+x} ]; then echo "/vagrant"; else echo "$(TRAVIS_BUILD_DIR)"; fi)
bin_dir      = ~/.bin
src_dir      = ~/.src
drush_dir    = ~/.drush
user         = $(shell whoami)
bashrc       = export PATH="$$PATH:$$HOME/.bin"
help_hooks   = $(shell grep "^help-[^:]*" .mk -rho)
deps_hooks   = $(shell grep "^deps-[^:]*" .mk -rho)

init: vm
	@mkdir -p $(bin_dir)
	@mkdir -p $(src_dir)
	@mkdir -p $(drush_dir)
	@grep -q -F '$(bashrc)' ~/.bashrc || echo '$(bashrc)' >> ~/.bashrc

deps: mysql-server $(deps_hooks) utilities

aptitude-update: vagrant
	@echo Updating apt
	@sudo DEBIAN_FRONTEND=noninteractive apt-get update -qq

fix-time:
	@sudo ntpdate -s time.nist.gov

help: $(help_hooks)

utilities: vagrant aptitude-update
	@echo Installing some utilities
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install screen htop strace tree

mysql-server: vagrant aptitude-update
	@echo Installing MySQL server
	@echo 'mysql-server mysql-server/root_password password' | sudo debconf-set-selections
	@echo 'mysql-server mysql-server/root_password_again password' | sudo debconf-set-selections
	@sudo DEBIAN_FRONTEND=noninteractive apt-get -y -qq install mysql-server

clean: vm
	@rm -rf $(bin_dir)
	@rm -rf $(src_dir)
	@rm -rf $(drush_dir)

vm:
ifneq ($(user), vagrant)
ifneq ($(user), travis)
	@echo Current user is \'$(user)\'.
	@echo This command \(make $@\) must be built in a \'vagrant\' or \'travis\' vm.
	@exit 1
endif
endif

vagrant:
ifneq ($(user), vagrant)
	@echo Current user is \'$(user)\'.
	@echo This command \(make $@\) must be built in a \'vagrant\' vm.
	@exit 1
endif

