###########################################################
#
# fontconfig
#
###########################################################

#
# FONTCONFIG_VERSION, FONTCONFIG_SITE and FONTCONFIG_SOURCE define
# the upstream location of the source code for the package.
# FONTCONFIG_DIR is the directory which is created when the source
# archive is unpacked.
#
FONTCONFIG_SITE=http://freedesktop.org
FONTCONFIG_SOURCE=# none - available from CVS only
FONTCONFIG_VERSION=2.2.99
FONTCONFIG_REPOSITORY=:pserver:anoncvs@freedesktop.org:/cvs/fontconfig
FONTCONFIG_DIR=fontconfig
FONTCONFIG_CVS_OPTS=-r fc-2_2_99
FONTCONFIG_MAINTAINER=Josh Parsons <jbparsons@ucdavis.edu>
FONTCONFIG_DESCRIPTION=Font configuration library
FONTCONFIG_SECTION=lib
FONTCONFIG_PRIORITY=optional
FONTCONFIG_DEPENDS=expat, freetype

#
# FONTCONFIG_IPK_VERSION should be incremented when the ipk changes.
#
FONTCONFIG_IPK_VERSION=1

#
# FONTCONFIG_CONFFILES should be a list of user-editable files
FONTCONFIG_CONFFILES=

#
# FONTCONFIG_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
FONTCONFIG_PATCHES=

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
FONTCONFIG_CPPFLAGS=
FONTCONFIG_LDFLAGS=

#
# FONTCONFIG_BUILD_DIR is the directory in which the build is done.
# FONTCONFIG_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# FONTCONFIG_IPK_DIR is the directory in which the ipk is built.
# FONTCONFIG_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
FONTCONFIG_BUILD_DIR=$(BUILD_DIR)/fontconfig
FONTCONFIG_SOURCE_DIR=$(SOURCE_DIR)/fontconfig
FONTCONFIG_IPK_DIR=$(BUILD_DIR)/fontconfig-$(FONTCONFIG_VERSION)-ipk
FONTCONFIG_IPK=$(BUILD_DIR)/fontconfig_$(FONTCONFIG_VERSION)-$(FONTCONFIG_IPK_VERSION)_armeb.ipk

#
# Automatically create a ipkg control file
#
$(FONTCONFIG_SOURCE_DIR)/control:
	@rm -f $@
	@mkdir -p $(FONTCONFIG_SOURCE_DIR) || true
	@echo "Package: fontconfig" >>$@
	@echo "Architecture: armeb" >>$@
	@echo "Priority: $(FONTCONFIG_PRIORITY)" >>$@
	@echo "Section: $(FONTCONFIG_SECTION)" >>$@
	@echo "Version: $(FONTCONFIG_VERSION)-$(FONTCONFIG_IPK_VERSION)" >>$@
	@echo "Maintainer: $(FONTCONFIG_MAINTAINER)" >>$@
	@echo "Source: $(FONTCONFIG_SITE)/$(FONTCONFIG_SOURCE)" >>$@
	@echo "Description: $(FONTCONFIG_DESCRIPTION)" >>$@
	@echo "Depends: $(FONTCONFIG_DEPENDS)" >>$@

#
# In this case there is no tarball, instead we fetch the sources
# directly to the builddir with CVS
#
$(FONTCONFIG_BUILD_DIR)/.fetched:
	rm -rf $(FONTCONFIG_BUILD_DIR) $(BUILD_DIR)/$(FONTCONFIG_DIR)
	( cd $(BUILD_DIR); \
		cvs -d $(FONTCONFIG_REPOSITORY) -z3 co $(FONTCONFIG_CVS_OPTS) $(FONTCONFIG_DIR); \
	)
	touch $@

fontconfig-source: $(FONTCONFIG_BUILD_DIR)/.fetched $(FONTCONFIG_PATCHES)

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
$(FONTCONFIG_BUILD_DIR)/.configured: $(FONTCONFIG_BUILD_DIR)/.fetched $(FONTCONFIG_PATCHES)
	$(MAKE) expat-stage freetype-stage
	(cd $(FONTCONFIG_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(FONTCONFIG_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(FONTCONFIG_LDFLAGS)" \
		PKG_CONFIG_PATH="$(STAGING_LIB_DIR)/pkgconfig" \
		PKG_CONFIG_LIBDIR="$(STAGING_LIB_DIR)/pkgconfig" \
		./autogen.sh \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=/opt \
		--with-default-fonts=/opt/share/fonts \
		--without-add-fonts \
		--disable-nls \
		--disable-docs \
		--disable-static \
	)
	touch $(FONTCONFIG_BUILD_DIR)/.configured

fontconfig-unpack: $(FONTCONFIG_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(FONTCONFIG_BUILD_DIR)/.built: $(FONTCONFIG_BUILD_DIR)/.configured
	rm -f $(FONTCONFIG_BUILD_DIR)/.built
	$(MAKE) -C $(FONTCONFIG_BUILD_DIR)
	touch $(FONTCONFIG_BUILD_DIR)/.built

#
# This is the build convenience target.
#
fontconfig: $(FONTCONFIG_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(FONTCONFIG_BUILD_DIR)/.staged: $(FONTCONFIG_BUILD_DIR)/.built
	rm -f $(FONTCONFIG_BUILD_DIR)/.staged
	$(MAKE) -C $(FONTCONFIG_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	rm -f $(STAGING_LIB_DIR)/libfontconfig.la
	touch $(FONTCONFIG_BUILD_DIR)/.staged

fontconfig-stage: $(FONTCONFIG_BUILD_DIR)/.staged

#
# This builds the IPK file.
#
# Binaries should be installed into $(FONTCONFIG_IPK_DIR)/opt/sbin or $(FONTCONFIG_IPK_DIR)/opt/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(FONTCONFIG_IPK_DIR)/opt/{lib,include}
# Configuration files should be installed in $(FONTCONFIG_IPK_DIR)/opt/etc/fontconfig/...
# Documentation files should be installed in $(FONTCONFIG_IPK_DIR)/opt/doc/fontconfig/...
# Daemon startup scripts should be installed in $(FONTCONFIG_IPK_DIR)/opt/etc/init.d/S??fontconfig
#
# You may need to patch your application to make it use these locations.
#
$(FONTCONFIG_IPK): $(FONTCONFIG_BUILD_DIR)/.built
	rm -rf $(FONTCONFIG_IPK_DIR) $(BUILD_DIR)/fontconfig_*_armeb.ipk $(FONTCONFIG_SOURCE_DIR)/control
	$(MAKE) $(FONTCONFIG_SOURCE_DIR)/control
	$(MAKE) -C $(FONTCONFIG_BUILD_DIR) DESTDIR=$(FONTCONFIG_IPK_DIR) install-strip
	rm -f $(FONTCONFIG_IPK_DIR)/opt/lib/*.la
	install -d $(FONTCONFIG_IPK_DIR)/CONTROL
	install -m 644 $(FONTCONFIG_SOURCE_DIR)/control $(FONTCONFIG_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(FONTCONFIG_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
fontconfig-ipk: $(FONTCONFIG_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
fontconfig-clean:
	-$(MAKE) -C $(FONTCONFIG_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
fontconfig-dirclean:
	rm -rf $(BUILD_DIR)/$(FONTCONFIG_DIR) $(FONTCONFIG_BUILD_DIR) $(FONTCONFIG_IPK_DIR) $(FONTCONFIG_IPK) $(FONTCONFIG_SOURCE_DIR)/control
