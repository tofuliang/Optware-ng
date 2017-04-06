###########################################################
#
# php-swoole
#
###########################################################
#
# PHP_SWOOLE_VERSION, PHP_SWOOLE_SITE and PHP_SWOOLE_SOURCE define
# the upstream location of the source code for the package.
# PHP_SWOOLE_DIR is the directory which is created when the source
# archive is unpacked.
# PHP_SWOOLE_UNZIP is the command used to unzip the source.
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
PHP_SWOOLE_VERSION=2.0.7
PHP_SWOOLE_REPOSITORY=https://github.com/swoole/swoole-src/archive/
PHP_SWOOLE_SOURCE=v$(PHP_SWOOLE_VERSION).tar.gz
PHP_SWOOLE_DIR=swoole-src-$(PHP_SWOOLE_VERSION)
PHP_SWOOLE_UNZIP=zcat
PHP_SWOOLE_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
PHP_SWOOLE_DESCRIPTION=PHP memcached extension based on libmemcached library.
PHP_SWOOLE_SECTION=net
PHP_SWOOLE_PRIORITY=optional
PHP_SWOOLE_DEPENDS=php
PHP_SWOOLE_SUGGESTS=
PHP_SWOOLE_CONFLICTS=

#
# PHP_SWOOLE_IPK_VERSION should be incremented when the ipk changes.
#
PHP_SWOOLE_IPK_VERSION=1

#
# PHP_SWOOLE_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#PHP_SWOOLE_PATCHES=$(PHP_SWOOLE_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PHP_SWOOLE_CPPFLAGS=
PHP_SWOOLE_LDFLAGS=

#
# PHP_SWOOLE_BUILD_DIR is the directory in which the build is done.
# PHP_SWOOLE_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PHP_SWOOLE_IPK_DIR is the directory in which the ipk is built.
# PHP_SWOOLE_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PHP_SWOOLE_BUILD_DIR=$(BUILD_DIR)/php-swoole
PHP_SWOOLE_SOURCE_DIR=$(SOURCE_DIR)/php-swoole
PHP_SWOOLE_IPK_DIR=$(BUILD_DIR)/php-swoole-$(PHP_SWOOLE_VERSION)-ipk
PHP_SWOOLE_IPK=$(BUILD_DIR)/php-swoole_$(PHP_SWOOLE_VERSION)-$(PHP_SWOOLE_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: php-swoole-source php-swoole-unpack php-swoole php-swoole-stage php-swoole-ipk php-swoole-clean php-swoole-dirclean php-swoole-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
# $(PHP_SWOOLE_URL) holds the link to the source,
# which is saved to $(DL_DIR)/$(PHP_SWOOLE_SOURCE).
# When adding new package, remember to place sha512sum of the source to
# scripts/checksums/$(PHP_SWOOLE_SOURCE).sha512
#
$(DL_DIR)/$(PHP_SWOOLE_SOURCE):
	$(WGET) -P $(@D) $(PHP_SWOOLE_REPOSITORY)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
php-swoole-source: $(DL_DIR)/$(PHP_SWOOLE_SOURCE) $(PHP_SWOOLE_PATCHES)

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
$(PHP_SWOOLE_BUILD_DIR)/.configured: $(DL_DIR)/$(PHP_SWOOLE_SOURCE) $(PHP_SWOOLE_PATCHES) make/php-swoole.mk
	$(MAKE) php-stage autoconf-host-stage libtool-host-stage
	rm -rf $(BUILD_DIR)/$(PHP_SWOOLE_DIR) $(@D)
	$(PHP_SWOOLE_UNZIP) $(DL_DIR)/$(PHP_SWOOLE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(PHP_SWOOLE_PATCHES)" ; \
		then cat $(PHP_SWOOLE_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(PHP_SWOOLE_DIR) -p1 ; \
	fi
	if test "$(BUILD_DIR)/$(PHP_SWOOLE_DIR)" != "$(@D)" ; \
		then mv $(BUILD_DIR)/$(PHP_SWOOLE_DIR) $(@D) ; \
	fi
	mkdir -p $(@D)/build
	(cd $(@D); \
		$(HOST_STAGING_PREFIX)/bin/libtoolize -cifv && \
		PHP_AUTOCONF=$(HOST_STAGING_PREFIX)/bin/autoconf PHP_AUTOHEADER=$(HOST_STAGING_PREFIX)/bin/autoheader $(STAGING_DIR)/bin/phpize \
	)
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(PHP_SWOOLE_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(PHP_SWOOLE_LDFLAGS)" \
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

php-swoole-unpack: $(PHP_SWOOLE_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(PHP_SWOOLE_BUILD_DIR)/.built: $(PHP_SWOOLE_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)
	touch $@

#
# This is the build convenience target.
#
php-swoole: $(PHP_SWOOLE_BUILD_DIR)/.built

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/php-swoole
#
$(PHP_SWOOLE_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-swoole" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_SWOOLE_PRIORITY)" >>$@
	@echo "Section: $(PHP_SWOOLE_SECTION)" >>$@
	@echo "Version: $(PHP_SWOOLE_VERSION)-$(PHP_SWOOLE_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_SWOOLE_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SWOOLE_REPOSITORY)" >>$@
	@echo "Description: $(PHP_SWOOLE_DESCRIPTION)" >>$@
	@echo "Depends: $(PHP_SWOOLE_DEPENDS)" >>$@
	@echo "Suggests: $(PHP_SWOOLE_SUGGESTS)" >>$@
	@echo "Conflicts: $(PHP_SWOOLE_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/sbin or $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/etc/php-swoole/...
# Documentation files should be installed in $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/doc/php-swoole/...
# Daemon startup scripts should be installed in $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??php-swoole
#
# You may need to patch your application to make it use these locations.
#
$(PHP_SWOOLE_IPK): $(PHP_SWOOLE_BUILD_DIR)/.built
	rm -rf $(PHP_SWOOLE_IPK_DIR) $(BUILD_DIR)/php-swoole_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_SWOOLE_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	cp -af $(PHP_SWOOLE_BUILD_DIR)/modules/swoole.so $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/swoole.so
	$(STRIP_COMMAND) $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/swoole.so
	echo extension=swoole.so > $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/swoole.ini
	chmod 644 $(PHP_SWOOLE_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/swoole.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_SWOOLE_IPK_DIR)
	$(WHAT_TO_DO_WITH_IPK_DIR) $(PHP_SWOOLE_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
php-swoole-ipk: $(PHP_SWOOLE_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
php-swoole-clean:
	rm -f $(PHP_SWOOLE_BUILD_DIR)/.built
	-$(MAKE) -C $(PHP_SWOOLE_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
php-swoole-dirclean:
	rm -rf $(BUILD_DIR)/$(PHP_SWOOLE_DIR) $(PHP_SWOOLE_BUILD_DIR) $(PHP_SWOOLE_IPK_DIR) $(PHP_SWOOLE_IPK)
#
#
# Some sanity check for the package.
#
php-swoole-check: $(PHP_SWOOLE_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
