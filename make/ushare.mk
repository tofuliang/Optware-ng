###########################################################
#
# ushare
#
###########################################################

USHARE_SITE=http://ushare.geexbox.org/releases
USHARE_VERSION=1.1a
USHARE_SOURCE=ushare-$(USHARE_VERSION).tar.bz2
USHARE_DIR=ushare-$(USHARE_VERSION)
USHARE_UNZIP=bzcat
USHARE_MAINTAINER=Peter Enzerink <nslu2-ushare@enzerink.net>
USHARE_DESCRIPTION=A free UPnP A/V Media Server for Linux.
USHARE_SECTION=net
USHARE_PRIORITY=optional
USHARE_DEPENDS=libdlna, libupnp6
ifeq (libiconv, $(filter libiconv, $(PACKAGES)))
USHARE_DEPENDS+=, libiconv
endif
USHARE_SUGGESTS=
USHARE_CONFLICTS=

#
# USHARE_IPK_VERSION should be incremented when the ipk changes.
#
USHARE_IPK_VERSION=3

#
# USHARE_CONFFILES should be a list of user-editable files
USHARE_CONFFILES=$(TARGET_PREFIX)/etc/ushare.conf

#
# USHARE_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
USHARE_PATCHES=\
$(USHARE_SOURCE_DIR)/latest-upnp-api.patch \

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
USHARE_CPPFLAGS=-std=gnu89 -I$(STAGING_DIR)/libupnp6$(TARGET_PREFIX)/include
USHARE_LDFLAGS=-L$(STAGING_DIR)/libupnp6$(TARGET_PREFIX)/lib -Wl,-rpath-link,$(STAGING_DIR)/libupnp6$(TARGET_PREFIX)/lib
ifeq (uclibc, $(LIBC_STYLE))
USHARE_LDFLAGS +=-lpthread
endif
ifeq (libiconv, $(filter libiconv, $(PACKAGES)))
USHARE_LDFLAGS+=-liconv
endif
USHARE_IFACE=$(strip \
	$(if $(filter nslu2, $(OPTWARE_TARGET)), ixp0, \
	$(if $(filter cs05q3armel, $(OPTWARE_TARGET)), egiga0, \
	$(if $(and $(filter mips mipsel, $(TARGET_ARCH)), $(filter uclibc, $(LIBC_STYLE))), br0, \
))))

#
# USHARE_BUILD_DIR is the directory in which the build is done.
# USHARE_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# USHARE_IPK_DIR is the directory in which the ipk is built.
# USHARE_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
USHARE_BUILD_DIR=$(BUILD_DIR)/ushare
USHARE_SOURCE_DIR=$(SOURCE_DIR)/ushare
USHARE_IPK_DIR=$(BUILD_DIR)/ushare-$(USHARE_VERSION)-ipk
USHARE_IPK=$(BUILD_DIR)/ushare_$(USHARE_VERSION)-$(USHARE_IPK_VERSION)_$(TARGET_ARCH).ipk


.PHONY: ushare-source ushare-unpack ushare ushare-stage ushare-ipk ushare-clean ushare-dirclean ushare-check


#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(USHARE_SOURCE):
	$(WGET) -P $(DL_DIR) $(USHARE_SITE)/$(USHARE_SOURCE)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
ushare-source: $(DL_DIR)/$(USHARE_SOURCE) $(USHARE_PATCHES)

# Note forced define of autoconf variables prior to configure.
# For explanation see:
# http://wiki.buici.com/wiki/Autoconf_and_RPL_MALLOC

$(USHARE_BUILD_DIR)/.configured: $(DL_DIR)/$(USHARE_SOURCE) $(USHARE_PATCHES) make/ushare.mk
ifeq (libiconv, $(filter libiconv, $(PACKAGES)))
	$(MAKE) libiconv-stage
endif
	$(MAKE) libdlna-stage libupnp6-stage
	rm -rf $(BUILD_DIR)/$(USHARE_DIR) $(USHARE_BUILD_DIR)
	$(USHARE_UNZIP) $(DL_DIR)/$(USHARE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	if test -n "$(USHARE_PATCHES)" ; \
		then cat $(USHARE_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(USHARE_DIR) -p1 ; \
	fi
	if test "$(BUILD_DIR)/$(USHARE_DIR)" != "$(@D)" ; \
		then mv $(BUILD_DIR)/$(USHARE_DIR) $(@D) ; \
	fi
	sed -i -e 's|^USHARE_NAME=.*|USHARE_NAME=$(OPTWARE_TARGET)|' \
	       -e 's|^USHARE_IFACE=.*|USHARE_IFACE=$(USHARE_IFACE)|' \
		$(@D)/scripts/ushare.conf
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(USHARE_CPPFLAGS) $(STAGING_CPPFLAGS) -I$(@D)" \
		CFLAGS="$(USHARE_CPPFLAGS) $(STAGING_CPPFLAGS) -I$(@D)" \
		LDFLAGS="$(USHARE_LDFLAGS) $(STAGING_LDFLAGS)" \
		PKG_CONFIG_PATH="$(STAGING_DIR)/libupnp6$(TARGET_PREFIX)/lib/pkgconfig:$(STAGING_LIB_DIR)/pkgconfig" \
		PKG_CONFIG_LIBDIR="$(STAGING_LIB_DIR)/pkgconfig" \
		ac_cv_func_malloc_0_nonnull=yes \
		ac_cv_func_realloc_0_nonnull=yes \
		./configure \
		--prefix=$(TARGET_PREFIX) \
		--cross-compile \
		--cross-prefix=$(TARGET_CROSS) \
		--with-libupnp-dir=$(STAGING_PREFIX) \
		--enable-dlna \
		--with-libdlna-dir=$(STAGING_PREFIX) \
		--disable-nls \
	)
#	$(PATCH_LIBTOOL) $(USHARE_BUILD_DIR)/libtool
	touch $@

ushare-unpack: $(USHARE_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(USHARE_BUILD_DIR)/.built: $(USHARE_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)
	touch $@

#
# This is the build convenience target.
#
ushare: $(USHARE_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(USHARE_BUILD_DIR)/.staged: $(USHARE_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
	touch $@

ushare-stage: $(USHARE_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/ushare
#
$(USHARE_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: ushare" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(USHARE_PRIORITY)" >>$@
	@echo "Section: $(USHARE_SECTION)" >>$@
	@echo "Version: $(USHARE_VERSION)-$(USHARE_IPK_VERSION)" >>$@
	@echo "Maintainer: $(USHARE_MAINTAINER)" >>$@
	@echo "Source: $(USHARE_SITE)/$(USHARE_SOURCE)" >>$@
	@echo "Description: $(USHARE_DESCRIPTION)" >>$@
	@echo "Depends: $(USHARE_DEPENDS)" >>$@
	@echo "Suggests: $(USHARE_SUGGESTS)" >>$@
	@echo "Conflicts: $(USHARE_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(USHARE_IPK_DIR)$(TARGET_PREFIX)/sbin or $(USHARE_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(USHARE_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(USHARE_IPK_DIR)$(TARGET_PREFIX)/etc/ushare/...
# Documentation files should be installed in $(USHARE_IPK_DIR)$(TARGET_PREFIX)/doc/ushare/...
# Daemon startup scripts should be installed in $(USHARE_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??ushare
#
# You may need to patch your application to make it use these locations.
#
$(USHARE_IPK): $(USHARE_BUILD_DIR)/.built
	rm -rf $(USHARE_IPK_DIR) $(BUILD_DIR)/ushare_*_$(TARGET_ARCH).ipk
	$(MAKE) -C $(USHARE_BUILD_DIR) DESTDIR=$(USHARE_IPK_DIR) install
	$(INSTALL) -d $(USHARE_IPK_DIR)$(TARGET_PREFIX)/etc/
	$(INSTALL) -m 644 $(USHARE_BUILD_DIR)/scripts/ushare.conf $(USHARE_IPK_DIR)$(TARGET_PREFIX)/etc/ushare.conf
	$(INSTALL) -d $(USHARE_IPK_DIR)$(TARGET_PREFIX)/etc/init.d
	$(INSTALL) -m 755 $(USHARE_SOURCE_DIR)/ushare $(USHARE_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S99ushare
	$(MAKE) $(USHARE_IPK_DIR)/CONTROL/control
	$(INSTALL) -m 755 $(USHARE_SOURCE_DIR)/postinst $(USHARE_IPK_DIR)/CONTROL/postinst
	$(INSTALL) -m 755 $(USHARE_SOURCE_DIR)/prerm $(USHARE_IPK_DIR)/CONTROL/prerm
	echo $(USHARE_CONFFILES) | sed -e 's/ /\n/g' > $(USHARE_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(USHARE_IPK_DIR)
	$(WHAT_TO_DO_WITH_IPK_DIR) $(USHARE_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
ushare-ipk: $(USHARE_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
ushare-clean:
	rm -f $(USHARE_BUILD_DIR)/.built
	-$(MAKE) -C $(USHARE_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
ushare-dirclean:
	rm -rf $(BUILD_DIR)/$(USHARE_DIR) $(USHARE_BUILD_DIR) $(USHARE_IPK_DIR) $(USHARE_IPK)
#
#
# Some sanity check for the package.
#
ushare-check: $(USHARE_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $(USHARE_IPK)
