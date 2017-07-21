###########################################################
#
# php-tideways
#
###########################################################
#
# PHP_TIDEWAYS_VERSION, PHP_TIDEWAYS_SITE and PHP_TIDEWAYS_SOURCE define
# the upstream location of the source code for the package.
# PHP_TIDEWAYS_DIR is the directory which is created when the source
# archive is unpacked.
# PHP_TIDEWAYS_UNZIP is the command used to unzip the source.
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
PHP_TIDEWAYS_VERSION=4.1.2
PHP_TIDEWAYS_REPOSITORY=https://github.com/tideways/php-profiler-extension/archive
PHP_TIDEWAYS_SOURCE=v$(PHP_TIDEWAYS_VERSION).tar.gz
PHP_TIDEWAYS_DIR=php-profiler-extension-$(PHP_TIDEWAYS_VERSION)
PHP_TIDEWAYS_UNZIP=zcat
PHP_TIDEWAYS_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PHP_TIDEWAYS_DESCRIPTION=PHP memcached extension based on libmemcached library.
PHP_TIDEWAYS_SECTION=net
PHP_TIDEWAYS_PRIORITY=optional
PHP_TIDEWAYS_DEPENDS=php
PHP_TIDEWAYS_SUGGESTS=
PHP_TIDEWAYS_CONFLICTS=

#
# PHP_TIDEWAYS_IPK_VERSION should be incremented when the ipk changes.
#
PHP_TIDEWAYS_IPK_VERSION=1

#
# PHP_TIDEWAYS_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#PHP_TIDEWAYS_PATCHES=$(PHP_TIDEWAYS_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PHP_TIDEWAYS_CPPFLAGS=
PHP_TIDEWAYS_LDFLAGS=

#
# PHP_TIDEWAYS_BUILD_DIR is the directory in which the build is done.
# PHP_TIDEWAYS_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PHP_TIDEWAYS_IPK_DIR is the directory in which the ipk is built.
# PHP_TIDEWAYS_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PHP_TIDEWAYS_BUILD_DIR=$(BUILD_DIR)/php-tideways
PHP_TIDEWAYS_SOURCE_DIR=$(SOURCE_DIR)/php-tideways
PHP_TIDEWAYS_IPK_DIR=$(BUILD_DIR)/php-tideways-$(PHP_TIDEWAYS_VERSION)-ipk
PHP_TIDEWAYS_IPK=$(BUILD_DIR)/php-tideways_$(PHP_TIDEWAYS_VERSION)-$(PHP_TIDEWAYS_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: php-tideways-source php-tideways-unpack php-tideways php-tideways-stage php-tideways-ipk php-tideways-clean php-tideways-dirclean php-tideways-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
# $(PHP_TIDEWAYS_URL) holds the link to the source,
# which is saved to $(DL_DIR)/$(PHP_TIDEWAYS_SOURCE).
# When adding new package, remember to place sha512sum of the source to
# scripts/checksums/$(PHP_TIDEWAYS_SOURCE).sha512
#
$(DL_DIR)/$(PHP_TIDEWAYS_SOURCE):
	$(WGET) -P $(@D) $(PHP_TIDEWAYS_REPOSITORY)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
php-tideways-source: $(DL_DIR)/$(PHP_TIDEWAYS_SOURCE) $(PHP_TIDEWAYS_PATCHES)

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
$(PHP_TIDEWAYS_BUILD_DIR)/.configured: $(DL_DIR)/$(PHP_TIDEWAYS_SOURCE) $(PHP_TIDEWAYS_PATCHES) make/php-tideways.mk
	$(MAKE) php-stage autoconf-host-stage libtool-host-stage
	rm -rf $(BUILD_DIR)/$(PHP_TIDEWAYS_DIR) $(@D)
	$(PHP_TIDEWAYS_UNZIP) $(DL_DIR)/$(PHP_TIDEWAYS_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(PHP_TIDEWAYS_PATCHES)" ; \
		then cat $(PHP_TIDEWAYS_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(PHP_TIDEWAYS_DIR) -p1 ; \
	fi
	if test "$(BUILD_DIR)/$(PHP_TIDEWAYS_DIR)" != "$(@D)" ; \
		then mv $(BUILD_DIR)/$(PHP_TIDEWAYS_DIR) $(@D) ; \
	fi
	mkdir -p $(@D)/build
	(cd $(@D); \
		$(HOST_STAGING_PREFIX)/bin/libtoolize -cifv && \
		PHP_AUTOCONF=$(HOST_STAGING_PREFIX)/bin/autoconf PHP_AUTOHEADER=$(HOST_STAGING_PREFIX)/bin/autoheader $(STAGING_DIR)/bin/phpize \
	)
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(PHP_TIDEWAYS_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(PHP_TIDEWAYS_LDFLAGS)" \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=$(TARGET_PREFIX) \
		--disable-nls \
		--disable-static \
		--with-php-config=$(STAGING_DIR)/bin/php-config \
	)
	$(PATCH_LIBTOOL) $(@D)/libtool
	touch $@

php-tideways-unpack: $(PHP_TIDEWAYS_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(PHP_TIDEWAYS_BUILD_DIR)/.built: $(PHP_TIDEWAYS_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)
	touch $@

#
# This is the build convenience target.
#
php-tideways: $(PHP_TIDEWAYS_BUILD_DIR)/.built

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/php-tideways
#
$(PHP_TIDEWAYS_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-tideways" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_TIDEWAYS_PRIORITY)" >>$@
	@echo "Section: $(PHP_TIDEWAYS_SECTION)" >>$@
	@echo "Version: $(PHP_TIDEWAYS_VERSION)-$(PHP_TIDEWAYS_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_TIDEWAYS_MAINTAINER)" >>$@
	@echo "Source: $(PHP_TIDEWAYS_REPOSITORY)" >>$@
	@echo "Description: $(PHP_TIDEWAYS_DESCRIPTION)" >>$@
	@echo "Depends: $(PHP_TIDEWAYS_DEPENDS)" >>$@
	@echo "Suggests: $(PHP_TIDEWAYS_SUGGESTS)" >>$@
	@echo "Conflicts: $(PHP_TIDEWAYS_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/sbin or $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/etc/php-tideways/...
# Documentation files should be installed in $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/doc/php-tideways/...
# Daemon startup scripts should be installed in $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??php-tideways
#
# You may need to patch your application to make it use these locations.
#
$(PHP_TIDEWAYS_IPK): $(PHP_TIDEWAYS_BUILD_DIR)/.built
	rm -rf $(PHP_TIDEWAYS_IPK_DIR) $(BUILD_DIR)/php-tideways_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_TIDEWAYS_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	cp -af $(PHP_TIDEWAYS_BUILD_DIR)/modules/tideways.so $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/tideways.so
	$(STRIP_COMMAND) $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/tideways.so
	echo extension=tideways.so > $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/tideways.ini
	chmod 644 $(PHP_TIDEWAYS_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/tideways.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_TIDEWAYS_IPK_DIR)
	$(WHAT_TO_DO_WITH_IPK_DIR) $(PHP_TIDEWAYS_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
php-tideways-ipk: $(PHP_TIDEWAYS_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
php-tideways-clean:
	rm -f $(PHP_TIDEWAYS_BUILD_DIR)/.built
	-$(MAKE) -C $(PHP_TIDEWAYS_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
php-tideways-dirclean:
	rm -rf $(BUILD_DIR)/$(PHP_TIDEWAYS_DIR) $(PHP_TIDEWAYS_BUILD_DIR) $(PHP_TIDEWAYS_IPK_DIR) $(PHP_TIDEWAYS_IPK)
#
#
# Some sanity check for the package.
#
php-tideways-check: $(PHP_TIDEWAYS_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
