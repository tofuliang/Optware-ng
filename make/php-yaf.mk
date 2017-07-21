###########################################################
#
# php-yaf
#
###########################################################
#
# PHP_YAF_VERSION, PHP_YAF_SITE and PHP_YAF_SOURCE define
# the upstream location of the source code for the package.
# PHP_YAF_DIR is the directory which is created when the source
# archive is unpacked.
# PHP_YAF_UNZIP is the command used to unzip the source.
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
PHP_YAF_VERSION=3.0.5
PHP_YAF_REPOSITORY=https://github.com/laruence/yaf/archive/
PHP_YAF_SOURCE=yaf-$(PHP_YAF_VERSION).tar.gz
PHP_YAF_DIR=yaf-yaf-$(PHP_YAF_VERSION)
PHP_YAF_UNZIP=zcat
PHP_YAF_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PHP_YAF_DESCRIPTION=PHP memcached extension based on libmemcached library.
PHP_YAF_SECTION=net
PHP_YAF_PRIORITY=optional
PHP_YAF_DEPENDS=php
PHP_YAF_SUGGESTS=
PHP_YAF_CONFLICTS=

#
# PHP_YAF_IPK_VERSION should be incremented when the ipk changes.
#
PHP_YAF_IPK_VERSION=1

#
# PHP_YAF_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#PHP_YAF_PATCHES=$(PHP_YAF_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PHP_YAF_CPPFLAGS=
PHP_YAF_LDFLAGS=

#
# PHP_YAF_BUILD_DIR is the directory in which the build is done.
# PHP_YAF_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PHP_YAF_IPK_DIR is the directory in which the ipk is built.
# PHP_YAF_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PHP_YAF_BUILD_DIR=$(BUILD_DIR)/php-yaf
PHP_YAF_SOURCE_DIR=$(SOURCE_DIR)/php-yaf
PHP_YAF_IPK_DIR=$(BUILD_DIR)/php-yaf-$(PHP_YAF_VERSION)-ipk
PHP_YAF_IPK=$(BUILD_DIR)/php-yaf_$(PHP_YAF_VERSION)-$(PHP_YAF_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: php-yaf-source php-yaf-unpack php-yaf php-yaf-stage php-yaf-ipk php-yaf-clean php-yaf-dirclean php-yaf-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
# $(PHP_YAF_URL) holds the link to the source,
# which is saved to $(DL_DIR)/$(PHP_YAF_SOURCE).
# When adding new package, remember to place sha512sum of the source to
# scripts/checksums/$(PHP_YAF_SOURCE).sha512
#
$(DL_DIR)/$(PHP_YAF_SOURCE):
	$(WGET) -P $(@D) $(PHP_YAF_REPOSITORY)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
php-yaf-source: $(DL_DIR)/$(PHP_YAF_SOURCE) $(PHP_YAF_PATCHES)

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
$(PHP_YAF_BUILD_DIR)/.configured: $(DL_DIR)/$(PHP_YAF_SOURCE) $(PHP_YAF_PATCHES) make/php-yaf.mk
	$(MAKE) php-stage autoconf-host-stage libtool-host-stage
	rm -rf $(BUILD_DIR)/$(PHP_YAF_DIR) $(@D)
	$(PHP_YAF_UNZIP) $(DL_DIR)/$(PHP_YAF_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(PHP_YAF_PATCHES)" ; \
		then cat $(PHP_YAF_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(PHP_YAF_DIR) -p1 ; \
	fi
	if test "$(BUILD_DIR)/$(PHP_YAF_DIR)" != "$(@D)" ; \
		then mv $(BUILD_DIR)/$(PHP_YAF_DIR) $(@D) ; \
	fi
	mkdir -p $(@D)/build
	(cd $(@D); \
		$(HOST_STAGING_PREFIX)/bin/libtoolize -cifv && \
		PHP_AUTOCONF=$(HOST_STAGING_PREFIX)/bin/autoconf PHP_AUTOHEADER=$(HOST_STAGING_PREFIX)/bin/autoheader $(STAGING_DIR)/bin/phpize \
	)
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(PHP_YAF_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(PHP_YAF_LDFLAGS)" \
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

php-yaf-unpack: $(PHP_YAF_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(PHP_YAF_BUILD_DIR)/.built: $(PHP_YAF_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)
	touch $@

#
# This is the build convenience target.
#
php-yaf: $(PHP_YAF_BUILD_DIR)/.built

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/php-yaf
#
$(PHP_YAF_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-yaf" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_YAF_PRIORITY)" >>$@
	@echo "Section: $(PHP_YAF_SECTION)" >>$@
	@echo "Version: $(PHP_YAF_VERSION)-$(PHP_YAF_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_YAF_MAINTAINER)" >>$@
	@echo "Source: $(PHP_YAF_REPOSITORY)" >>$@
	@echo "Description: $(PHP_YAF_DESCRIPTION)" >>$@
	@echo "Depends: $(PHP_YAF_DEPENDS)" >>$@
	@echo "Suggests: $(PHP_YAF_SUGGESTS)" >>$@
	@echo "Conflicts: $(PHP_YAF_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/sbin or $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/etc/php-yaf/...
# Documentation files should be installed in $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/doc/php-yaf/...
# Daemon startup scripts should be installed in $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??php-yaf
#
# You may need to patch your application to make it use these locations.
#
$(PHP_YAF_IPK): $(PHP_YAF_BUILD_DIR)/.built
	rm -rf $(PHP_YAF_IPK_DIR) $(BUILD_DIR)/php-yaf_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_YAF_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	cp -af $(PHP_YAF_BUILD_DIR)/modules/yaf.so $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/yaf.so
	$(STRIP_COMMAND) $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/yaf.so
	echo extension=yaf.so > $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/yaf.ini
	chmod 644 $(PHP_YAF_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/yaf.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_YAF_IPK_DIR)
	$(WHAT_TO_DO_WITH_IPK_DIR) $(PHP_YAF_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
php-yaf-ipk: $(PHP_YAF_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
php-yaf-clean:
	rm -f $(PHP_YAF_BUILD_DIR)/.built
	-$(MAKE) -C $(PHP_YAF_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
php-yaf-dirclean:
	rm -rf $(BUILD_DIR)/$(PHP_YAF_DIR) $(PHP_YAF_BUILD_DIR) $(PHP_YAF_IPK_DIR) $(PHP_YAF_IPK)
#
#
# Some sanity check for the package.
#
php-yaf-check: $(PHP_YAF_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
