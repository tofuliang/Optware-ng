###########################################################
#
# php-phalcon
#
###########################################################
#
# PHP_PHALCON_VERSION, PHP_PHALCON_SITE and PHP_PHALCON_SOURCE define
# the upstream location of the source code for the package.
# PHP_PHALCON_DIR is the directory which is created when the source
# archive is unpacked.
# PHP_PHALCON_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
# You should change all these variables to suit your package.
# Please make sure that you add a description, and that you
# list all your packages' dependencies, seperated by commas.
# 
# If you list yourself as MAINTAINER, please give a valid email
# address, and indicate your irc nick if it cannot be easily deduced
# from your name or email address.  If you leave MAINTAINER set to
# "NSLU2 Linux" other developers will feel free to edit.
#
PHP_PHALCON_VERSION=3.1.2
PHP_PHALCON_REPOSITORY=https://github.com/phalcon/cphalcon/archive/
PHP_PHALCON_SOURCE=v$(PHP_PHALCON_VERSION).tar.gz
PHP_PHALCON_DIR=cphalcon-$(PHP_PHALCON_VERSION)
PHP_PHALCON_UNZIP=zcat
PHP_PHALCON_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PHP_PHALCON_DESCRIPTION=PHP memcached extension based on libmemcached library.
PHP_PHALCON_SECTION=net
PHP_PHALCON_PRIORITY=optional
PHP_PHALCON_DEPENDS=php
PHP_PHALCON_SUGGESTS=
PHP_PHALCON_CONFLICTS=

#
# PHP_PHALCON_IPK_VERSION should be incremented when the ipk changes.
#
PHP_PHALCON_IPK_VERSION=1

#
# PHP_PHALCON_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#PHP_PHALCON_PATCHES=$(PHP_PHALCON_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PHP_PHALCON_CPPFLAGS=
PHP_PHALCON_LDFLAGS=

#
# PHP_PHALCON_BUILD_DIR is the directory in which the build is done.
# PHP_PHALCON_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PHP_PHALCON_IPK_DIR is the directory in which the ipk is built.
# PHP_PHALCON_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PHP_PHALCON_BUILD_DIR=$(BUILD_DIR)/php-phalcon
PHP_PHALCON_SOURCE_DIR=$(SOURCE_DIR)/php-phalcon
PHP_PHALCON_IPK_DIR=$(BUILD_DIR)/php-phalcon-$(PHP_PHALCON_VERSION)-ipk
PHP_PHALCON_IPK=$(BUILD_DIR)/php-phalcon_$(PHP_PHALCON_VERSION)-$(PHP_PHALCON_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: php-phalcon-source php-phalcon-unpack php-phalcon php-phalcon-stage php-phalcon-ipk php-phalcon-clean php-phalcon-dirclean php-phalcon-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
# $(PHP_PHALCON_URL) holds the link to the source,
# which is saved to $(DL_DIR)/$(PHP_PHALCON_SOURCE).
# When adding new package, remember to place sha512sum of the source to
# scripts/checksums/$(PHP_PHALCON_SOURCE).sha512
#
$(DL_DIR)/$(PHP_PHALCON_SOURCE):
	$(WGET) -P $(@D) $(PHP_PHALCON_REPOSITORY)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
php-phalcon-source: $(DL_DIR)/$(PHP_PHALCON_SOURCE) $(PHP_PHALCON_PATCHES)

#
# This target unpacks the source code in the build directory.
# If the source archive is not .tar.gz or .tar.bz2, then you will need
# to change the commands here.  Patches to the source code are also
# applied in this target as required.
#
# This target also configures the build within the build directory.
# Flags such as LDFLAGS and CPPFLAGS should be passed into configure
# and NOT $(MAKE) below.  Passing it to configure causes configure to
# correctly BUILD the Makefile with the right paths, where passing it
# to Make causes it to override the default search paths of the compiler.
#
# If the compilation of the package requires other packages to be staged
# first, then do that first (e.g. "$(MAKE) <bar>-stage <baz>-stage").
#
# If the package uses  GNU libtool, you should invoke $(PATCH_LIBTOOL) as
# shown below to make various patches to it.
#
$(PHP_PHALCON_BUILD_DIR)/.configured: $(DL_DIR)/$(PHP_PHALCON_SOURCE) $(PHP_PHALCON_PATCHES) make/php-phalcon.mk
	$(MAKE) php-stage autoconf-host-stage libtool-host-stage
	rm -rf $(BUILD_DIR)/$(PHP_PHALCON_DIR) $(@D)
	$(PHP_PHALCON_UNZIP) $(DL_DIR)/$(PHP_PHALCON_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(PHP_PHALCON_PATCHES)" ; \
		then cat $(PHP_PHALCON_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(PHP_PHALCON_DIR) -p1 ; \
	fi
	if test "$(BUILD_DIR)/$(PHP_PHALCON_DIR)" != "$(@D)" ; \
		then mv $(BUILD_DIR)/$(PHP_PHALCON_DIR) $(@D) ; \
	fi
	mkdir -p $(@D)/build
	(cd $(@D)/build/php7/32bits; \
		$(HOST_STAGING_PREFIX)/bin/libtoolize -cifv && \
		PHP_AUTOCONF=$(HOST_STAGING_PREFIX)/bin/autoconf PHP_AUTOHEADER=$(HOST_STAGING_PREFIX)/bin/autoheader $(STAGING_DIR)/bin/phpize \
	)
	(cd $(@D)/build/php7/32bits; \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(PHP_PHALCON_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(PHP_PHALCON_LDFLAGS)" \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=$(TARGET_PREFIX) \
		--disable-nls \
		--disable-static \
		--with-php-config=$(STAGING_DIR)/bin/php-config \
	)
	$(PATCH_LIBTOOL) $(@D)/build/php7/32bits/libtool
	touch $@

php-phalcon-unpack: $(PHP_PHALCON_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(PHP_PHALCON_BUILD_DIR)/.built: $(PHP_PHALCON_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)/build/php7/32bits
	touch $@

#
# This is the build convenience target.
#
php-phalcon: $(PHP_PHALCON_BUILD_DIR)/.built

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/php-phalcon
#
$(PHP_PHALCON_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-phalcon" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PHALCON_PRIORITY)" >>$@
	@echo "Section: $(PHP_PHALCON_SECTION)" >>$@
	@echo "Version: $(PHP_PHALCON_VERSION)-$(PHP_PHALCON_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_PHALCON_MAINTAINER)" >>$@
	@echo "Source: $(PHP_PHALCON_REPOSITORY)" >>$@
	@echo "Description: $(PHP_PHALCON_DESCRIPTION)" >>$@
	@echo "Depends: $(PHP_PHALCON_DEPENDS)" >>$@
	@echo "Suggests: $(PHP_PHALCON_SUGGESTS)" >>$@
	@echo "Conflicts: $(PHP_PHALCON_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/sbin or $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/etc/php-phalcon/...
# Documentation files should be installed in $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/doc/php-phalcon/...
# Daemon startup scripts should be installed in $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??php-phalcon
#
# You may need to patch your application to make it use these locations.
#
$(PHP_PHALCON_IPK): $(PHP_PHALCON_BUILD_DIR)/.built
	rm -rf $(PHP_PHALCON_IPK_DIR) $(BUILD_DIR)/php-phalcon_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_PHALCON_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	cp -af $(PHP_PHALCON_BUILD_DIR)/build/php7/32bits/modules/phalcon.so $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/phalcon.so
	$(STRIP_COMMAND) $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/phalcon.so
	echo extension=phalcon.so > $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/phalcon.ini
	chmod 644 $(PHP_PHALCON_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/phalcon.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_PHALCON_IPK_DIR)
	$(WHAT_TO_DO_WITH_IPK_DIR) $(PHP_PHALCON_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
php-phalcon-ipk: $(PHP_PHALCON_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
php-phalcon-clean:
	rm -f $(PHP_PHALCON_BUILD_DIR)/.built
	-$(MAKE) -C $(PHP_PHALCON_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
php-phalcon-dirclean:
	rm -rf $(BUILD_DIR)/$(PHP_PHALCON_DIR) $(PHP_PHALCON_BUILD_DIR) $(PHP_PHALCON_IPK_DIR) $(PHP_PHALCON_IPK)
#
#
# Some sanity check for the package.
#
php-phalcon-check: $(PHP_PHALCON_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
