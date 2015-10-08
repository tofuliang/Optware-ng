###########################################################
#
# xaw
#
###########################################################

#
# XAW_VERSION, XAW_SITE and XAW_SOURCE define
# the upstream location of the source code for the package.
# XAW_DIR is the directory which is created when the source
# archive is unpacked.
#
XAW_SITE=http://xorg.freedesktop.org/releases/individual/lib
XAW_SOURCE=libXaw-$(XAW_VERSION).tar.gz
XAW_VERSION=1.0.12
XAW_FULL_VERSION=release-$(XAW_VERSION)
XAW_DIR=libXaw-$(XAW_VERSION)
XAW_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
XAW_DESCRIPTION=Athena widgets library
XAW_SECTION=lib
XAW_PRIORITY=optional
XAW_DEPENDS=xt, xmu, xpm

#
# XAW_IPK_VERSION should be incremented when the ipk changes.
#
XAW_IPK_VERSION=1

#
# XAW_CONFFILES should be a list of user-editable files
XAW_CONFFILES=

#
# XAW_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#XAW_PATCHES=$(XAW_SOURCE_DIR)/autogen.sh.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
XAW_CPPFLAGS=
XAW_LDFLAGS=

#
# XAW_BUILD_DIR is the directory in which the build is done.
# XAW_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# XAW_IPK_DIR is the directory in which the ipk is built.
# XAW_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
XAW_BUILD_DIR=$(BUILD_DIR)/xaw
XAW_SOURCE_DIR=$(SOURCE_DIR)/xaw
XAW_IPK_DIR=$(BUILD_DIR)/xaw-$(XAW_FULL_VERSION)-ipk
XAW_IPK=$(BUILD_DIR)/xaw_$(XAW_FULL_VERSION)-$(XAW_IPK_VERSION)_$(TARGET_ARCH).ipk

#
# Automatically create a ipkg control file
#
$(XAW_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(XAW_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: xaw" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(XAW_PRIORITY)" >>$@
	@echo "Section: $(XAW_SECTION)" >>$@
	@echo "Version: $(XAW_FULL_VERSION)-$(XAW_IPK_VERSION)" >>$@
	@echo "Maintainer: $(XAW_MAINTAINER)" >>$@
	@echo "Source: $(XAW_SITE)/$(XAW_SOURCE)" >>$@
	@echo "Description: $(XAW_DESCRIPTION)" >>$@
	@echo "Depends: $(XAW_DEPENDS)" >>$@

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(XAW_SOURCE):
	$(WGET) -P $(@D) $(XAW_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

xaw-source: $(DL_DIR)/$(XAW_SOURCE) $(XAW_PATCHES)

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
$(XAW_BUILD_DIR)/.configured: $(DL_DIR)/$(XAW_SOURCE) \
		$(XAW_PATCHES) make/xaw.mk
	$(MAKE) xt-stage xmu-stage xpm-stage
	rm -rf $(BUILD_DIR)/$(XAW_DIR) $(@D)
	tar -C $(BUILD_DIR) -xzf $(DL_DIR)/$(XAW_SOURCE)
	if test -n "$(XAW_PATCHES)" ; \
		then cat $(XAW_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(XAW_DIR) -p1 ; \
	fi
	if test "$(BUILD_DIR)/$(XAW_DIR)" != "$(XAW_BUILD_DIR)" ; \
		then mv $(BUILD_DIR)/$(XAW_DIR) $(XAW_BUILD_DIR) ; \
	fi
	(cd $(XAW_BUILD_DIR); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(XAW_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(XAW_LDFLAGS)" \
		PKG_CONFIG_PATH="$(STAGING_LIB_DIR)/pkgconfig" \
		PKG_CONFIG_LIBDIR="$(STAGING_LIB_DIR)/pkgconfig" \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--prefix=$(TARGET_PREFIX) \
		--disable-static \
	)
	$(PATCH_LIBTOOL) $(XAW_BUILD_DIR)/libtool
	touch $@

xaw-unpack: $(XAW_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(XAW_BUILD_DIR)/.built: $(XAW_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(XAW_BUILD_DIR)
	touch $@

#
# This is the build convenience target.
#
xaw: $(XAW_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(XAW_BUILD_DIR)/.staged: $(XAW_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(XAW_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	sed -ie 's|^prefix=.*|prefix=$(STAGING_PREFIX)|' \
		$(STAGING_LIB_DIR)/pkgconfig/xaw*.pc
	rm -f $(STAGING_LIB_DIR)/libXAW.la
	touch $@

xaw-stage: $(XAW_BUILD_DIR)/.staged

#
# This builds the IPK file.
#
$(XAW_IPK): $(XAW_BUILD_DIR)/.built
	rm -rf $(XAW_IPK_DIR) $(BUILD_DIR)/xaw_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(XAW_BUILD_DIR) DESTDIR=$(XAW_IPK_DIR) install-strip
	$(MAKE) $(XAW_IPK_DIR)/CONTROL/control
	rm -f $(XAW_IPK_DIR)$(TARGET_PREFIX)/lib/*.la
	cd $(BUILD_DIR); $(IPKG_BUILD) $(XAW_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
xaw-ipk: $(XAW_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
xaw-clean:
	rm -f $(XAW_BUILD_DIR)/.built
	-$(MAKE) -C $(XAW_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
xaw-dirclean:
	rm -rf $(BUILD_DIR)/$(XAW_DIR) $(XAW_BUILD_DIR) $(XAW_IPK_DIR) $(XAW_IPK)
