###########################################################
#
# asterisk14-moh-opsound-alaw
#
###########################################################
#
# ASTERISK14_MOH_OPSOUND_ALAW_VERSION, ASTERISK14_MOH_OPSOUND_ALAW_SITE and ASTERISK14_MOH_OPSOUND_ALAW_SOURCE define
# the upstream location of the source code for the package.
# ASTERISK14_MOH_OPSOUND_ALAW_DIR is the directory which is created when the source
# archive is unpacked.
# ASTERISK14_MOH_OPSOUND_ALAW_UNZIP is the command used to unzip the source.
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
ASTERISK14_MOH_OPSOUND_ALAW_SITE=http://downloads.asterisk.org/pub/telephony/sounds/releases
ASTERISK14_MOH_OPSOUND_ALAW_VERSION=2.03
#ASTERISK14_MOH_OPSOUND_ALAW_SOURCE=asterisk-moh-opsound-alaw-$(ASTERISK14_MOH_OPSOUND_ALAW_VERSION).tar.gz
ASTERISK14_MOH_OPSOUND_ALAW_SOURCE=asterisk-moh-opsound-alaw.tar.gz
ASTERISK14_MOH_OPSOUND_ALAW_DIR=asterisk-moh-opsound-alaw-$(ASTERISK14_MOH_OPSOUND_ALAW_VERSION)
ASTERISK14_MOH_OPSOUND_ALAW_UNZIP=zcat
ASTERISK14_MOH_OPSOUND_ALAW_MAINTAINER=Ovidiu Sas <osas@voipembedded.com>
ASTERISK14_MOH_OPSOUND_ALAW_DESCRIPTION=asterisk-moh-opsound-alaw
ASTERISK14_MOH_OPSOUND_ALAW_SECTION=misc
ASTERISK14_MOH_OPSOUND_ALAW_PRIORITY=optional
ASTERISK14_MOH_OPSOUND_ALAW_DEPENDS=
ASTERISK14_MOH_OPSOUND_ALAW_SUGGESTS=
ASTERISK14_MOH_OPSOUND_ALAW_CONFLICTS=asterisk-sounds,asterisk14-mof-freeplay

#
# ASTERISK14_MOH_OPSOUND_ALAW_IPK_VERSION should be incremented when the ipk changes.
#
ASTERISK14_MOH_OPSOUND_ALAW_IPK_VERSION=1

#
# ASTERISK14_MOH_OPSOUND_ALAW_CONFFILES should be a list of user-editable files
#ASTERISK14_MOH_OPSOUND_ALAW_CONFFILES=$(TARGET_PREFIX)/etc/asterisk14-moh-opsound-alaw.conf $(TARGET_PREFIX)/etc/init.d/SXXasterisk14-moh-opsound-alaw

#
# ASTERISK14_MOH_OPSOUND_ALAW_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#ASTERISK14_MOH_OPSOUND_ALAW_PATCHES=$(ASTERISK14_MOH_OPSOUND_ALAW_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
ASTERISK14_MOH_OPSOUND_ALAW_CPPFLAGS=
ASTERISK14_MOH_OPSOUND_ALAW_LDFLAGS=

#
# ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR is the directory in which the build is done.
# ASTERISK14_MOH_OPSOUND_ALAW_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR is the directory in which the ipk is built.
# ASTERISK14_MOH_OPSOUND_ALAW_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR=$(BUILD_DIR)/asterisk14-moh-opsound-alaw
ASTERISK14_MOH_OPSOUND_ALAW_SOURCE_DIR=$(SOURCE_DIR)/asterisk14-moh-opsound-alaw
ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR=$(BUILD_DIR)/asterisk14-moh-opsound-alaw-$(ASTERISK14_MOH_OPSOUND_ALAW_VERSION)-ipk
ASTERISK14_MOH_OPSOUND_ALAW_IPK=$(BUILD_DIR)/asterisk14-moh-opsound-alaw_$(ASTERISK14_MOH_OPSOUND_ALAW_VERSION)-$(ASTERISK14_MOH_OPSOUND_ALAW_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: asterisk14-moh-opsound-alaw-source asterisk14-moh-opsound-alaw-unpack asterisk14-moh-opsound-alaw asterisk14-moh-opsound-alaw-stage asterisk14-moh-opsound-alaw-ipk asterisk14-moh-opsound-alaw-clean asterisk14-moh-opsound-alaw-dirclean asterisk14-moh-opsound-alaw-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_SOURCE):
	$(WGET) -P $(DL_DIR) $(ASTERISK14_MOH_OPSOUND_ALAW_SITE)/$(ASTERISK14_MOH_OPSOUND_ALAW_SOURCE)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
#asterisk14-moh-opsound-alaw-source: $(DL_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_SOURCE) $(ASTERISK14_MOH_OPSOUND_ALAW_PATCHES)

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
$(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.configured: $(DL_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_SOURCE) $(ASTERISK14_MOH_OPSOUND_ALAW_PATCHES) make/asterisk14-moh-opsound-alaw.mk
	#$(MAKE) <bar>-stage <baz>-stage
	rm -rf $(BUILD_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_DIR) $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)
	mkdir -p $(BUILD_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_DIR); $(ASTERISK14_MOH_OPSOUND_ALAW_UNZIP) $(DL_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_SOURCE) | tar -C $(BUILD_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_DIR) -xvf -
	if test -n "$(ASTERISK14_MOH_OPSOUND_ALAW_PATCHES)" ; \
		then cat $(ASTERISK14_MOH_OPSOUND_ALAW_PATCHES) | \
		$(PATCH) -d $(BUILD_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_DIR) -p0 ; \
	fi
	if test "$(BUILD_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_DIR)" != "$(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)" ; \
		then mv $(BUILD_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_DIR) $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR) ; \
	fi
	touch $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.configured

asterisk14-moh-opsound-alaw-unpack: $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.built: $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.configured
	rm -f $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.built
	touch $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.built

#
# This is the build convenience target.
#
asterisk14-moh-opsound-alaw: $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.staged: $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.built
	rm -f $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.staged
	touch $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.staged

asterisk14-moh-opsound-alaw-stage: $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/asterisk14-moh-opsound-alaw
#
$(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: asterisk14-moh-opsound-alaw" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(ASTERISK14_MOH_OPSOUND_ALAW_PRIORITY)" >>$@
	@echo "Section: $(ASTERISK14_MOH_OPSOUND_ALAW_SECTION)" >>$@
	@echo "Version: $(ASTERISK14_MOH_OPSOUND_ALAW_VERSION)-$(ASTERISK14_MOH_OPSOUND_ALAW_IPK_VERSION)" >>$@
	@echo "Maintainer: $(ASTERISK14_MOH_OPSOUND_ALAW_MAINTAINER)" >>$@
	@echo "Source: $(ASTERISK14_MOH_OPSOUND_ALAW_SITE)/$(ASTERISK14_MOH_OPSOUND_ALAW_SOURCE)" >>$@
	@echo "Description: $(ASTERISK14_MOH_OPSOUND_ALAW_DESCRIPTION)" >>$@
	@echo "Depends: $(ASTERISK14_MOH_OPSOUND_ALAW_DEPENDS)" >>$@
	@echo "Suggests: $(ASTERISK14_MOH_OPSOUND_ALAW_SUGGESTS)" >>$@
	@echo "Conflicts: $(ASTERISK14_MOH_OPSOUND_ALAW_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)$(TARGET_PREFIX)/sbin or $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)$(TARGET_PREFIX)/etc/asterisk14-moh-opsound-alaw/...
# Documentation files should be installed in $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)$(TARGET_PREFIX)/doc/asterisk14-moh-opsound-alaw/...
# Daemon startup scripts should be installed in $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??asterisk14-moh-opsound-alaw
#
# You may need to patch your application to make it use these locations.
#
$(ASTERISK14_MOH_OPSOUND_ALAW_IPK): $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.built
	rm -rf $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR) $(BUILD_DIR)/asterisk14-moh-opsound-alaw_*_$(TARGET_ARCH).ipk
	$(MAKE) $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)$(TARGET_PREFIX)/var/lib/asterisk/moh
	$(INSTALL) -m 644 $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/*alaw $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)$(TARGET_PREFIX)/var/lib/asterisk/moh
	cd $(BUILD_DIR); $(IPKG_BUILD) $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
asterisk14-moh-opsound-alaw-ipk: $(ASTERISK14_MOH_OPSOUND_ALAW_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
asterisk14-moh-opsound-alaw-clean:
	rm -f $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR)/.built

#
# This is called from the top level makefile to clean all dynamically created
# directories.
asterisk14-moh-opsound-alaw-dirclean:
	rm -rf $(BUILD_DIR)/$(ASTERISK14_MOH_OPSOUND_ALAW_DIR) $(ASTERISK14_MOH_OPSOUND_ALAW_BUILD_DIR) $(ASTERISK14_MOH_OPSOUND_ALAW_IPK_DIR) $(ASTERISK14_MOH_OPSOUND_ALAW_IPK)
#
#
# Some sanity check for the package.
#
asterisk14-moh-opsound-alaw-check: $(ASTERISK14_MOH_OPSOUND_ALAW_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $(ASTERISK14_MOH_OPSOUND_ALAW_IPK)
