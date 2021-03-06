###########################################################
#
# bzr-rewrite
#
###########################################################

#
# BZR-REWRITE_VERSION, BZR-REWRITE_SITE and BZR-REWRITE_SOURCE define
# the upstream location of the source code for the package.
# BZR-REWRITE_DIR is the directory which is created when the source
# archive is unpacked.
# BZR-REWRITE_UNZIP is the command used to unzip the source.
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
BZR-REWRITE_VERSION=0.6.2
BZR-REWRITE_SITE=http://samba.org/~jelmer/bzr
BZR-REWRITE_SOURCE=bzr-rewrite-$(BZR-REWRITE_VERSION).tar.gz
BZR-REWRITE_DIR=bzr-rewrite-$(BZR-REWRITE_VERSION)
BZR-REWRITE_UNZIP=zcat
BZR-REWRITE_MAINTAINER=NSLU2 Linux <nslu2-linux@yahoogroups.com>
BZR-REWRITE_DESCRIPTION=Revision rewrite plugin for bzr.
BZR-REWRITE_SECTION=devel
BZR-REWRITE_PRIORITY=optional
PY25-BZR-REWRITE_DEPENDS=py25-bzr
PY26-BZR-REWRITE_DEPENDS=py26-bzr
BZR-REWRITE_CONFLICTS=

#
# BZR-REWRITE_IPK_VERSION should be incremented when the ipk changes.
#
BZR-REWRITE_IPK_VERSION=1

#
# BZR-REWRITE_CONFFILES should be a list of user-editable files
#BZR-REWRITE_CONFFILES=$(TARGET_PREFIX)/etc/bzr-rewrite.conf $(TARGET_PREFIX)/etc/init.d/SXXbzr-rewrite

#
# BZR-REWRITE_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#BZR-REWRITE_PATCHES=$(BZR-REWRITE_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
BZR-REWRITE_CPPFLAGS=
BZR-REWRITE_LDFLAGS=

#
# BZR-REWRITE_BUILD_DIR is the directory in which the build is done.
# BZR-REWRITE_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# BZR-REWRITE_IPK_DIR is the directory in which the ipk is built.
# BZR-REWRITE_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
BZR-REWRITE_BUILD_DIR=$(BUILD_DIR)/bzr-rewrite
BZR-REWRITE_SOURCE_DIR=$(SOURCE_DIR)/bzr-rewrite

PY25-BZR-REWRITE_IPK_DIR=$(BUILD_DIR)/py25-bzr-rewrite-$(BZR-REWRITE_VERSION)-ipk
PY25-BZR-REWRITE_IPK=$(BUILD_DIR)/py25-bzr-rewrite_$(BZR-REWRITE_VERSION)-$(BZR-REWRITE_IPK_VERSION)_$(TARGET_ARCH).ipk

PY26-BZR-REWRITE_IPK_DIR=$(BUILD_DIR)/py26-bzr-rewrite-$(BZR-REWRITE_VERSION)-ipk
PY26-BZR-REWRITE_IPK=$(BUILD_DIR)/py26-bzr-rewrite_$(BZR-REWRITE_VERSION)-$(BZR-REWRITE_IPK_VERSION)_$(TARGET_ARCH).ipk

.PHONY: bzr-rewrite-source bzr-rewrite-unpack bzr-rewrite bzr-rewrite-stage bzr-rewrite-ipk bzr-rewrite-clean bzr-rewrite-dirclean bzr-rewrite-check

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(BZR-REWRITE_SOURCE):
	$(WGET) -P $(@D) $(BZR-REWRITE_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
bzr-rewrite-source: $(DL_DIR)/$(BZR-REWRITE_SOURCE) $(BZR-REWRITE_PATCHES)

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
$(BZR-REWRITE_BUILD_DIR)/.configured: $(DL_DIR)/$(BZR-REWRITE_SOURCE) $(BZR-REWRITE_PATCHES) make/bzr-rewrite.mk
	$(MAKE) py-setuptools-stage
	rm -rf $(@D)
	mkdir -p $(@D)
	# 2.5
	$(BZR-REWRITE_UNZIP) $(DL_DIR)/$(BZR-REWRITE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(BZR-REWRITE_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(BZR-REWRITE_DIR) -p1
	mv $(BUILD_DIR)/$(BZR-REWRITE_DIR) $(@D)/2.5
	(cd $(@D)/2.5; \
	    ( \
		echo "[build_ext]"; \
	        echo "include-dirs=$(STAGING_INCLUDE_DIR):$(STAGING_INCLUDE_DIR)/python2.5"; \
	        echo "library-dirs=$(STAGING_LIB_DIR)"; \
	        echo "rpath=$(TARGET_PREFIX)/lib"; \
		echo "[build_scripts]"; \
		echo "executable=$(TARGET_PREFIX)/bin/python2.5"; \
		echo "[install]"; \
		echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg; \
	)
	# 2.6
	$(BZR-REWRITE_UNZIP) $(DL_DIR)/$(BZR-REWRITE_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(BZR-REWRITE_PATCHES) | $(PATCH) -d $(BUILD_DIR)/$(BZR-REWRITE_DIR) -p1
	mv $(BUILD_DIR)/$(BZR-REWRITE_DIR) $(@D)/2.6
	(cd $(@D)/2.6; \
	    ( \
		echo "[build_ext]"; \
	        echo "include-dirs=$(STAGING_INCLUDE_DIR):$(STAGING_INCLUDE_DIR)/python2.6"; \
	        echo "library-dirs=$(STAGING_LIB_DIR)"; \
	        echo "rpath=$(TARGET_PREFIX)/lib"; \
		echo "[build_scripts]"; \
		echo "executable=$(TARGET_PREFIX)/bin/python2.6"; \
		echo "[install]"; \
		echo "install_scripts=$(TARGET_PREFIX)/bin"; \
	    ) >> setup.cfg; \
	)
	touch $@

bzr-rewrite-unpack: $(BZR-REWRITE_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(BZR-REWRITE_BUILD_DIR)/.built: $(BZR-REWRITE_BUILD_DIR)/.configured
	rm -f $@
	(cd $(@D)/2.5; \
	$(TARGET_CONFIGURE_OPTS) LDSHARED='$(TARGET_CC) -shared' \
	    $(HOST_STAGING_PREFIX)/bin/python2.5 setup.py build; \
	)
	(cd $(@D)/2.6; \
	$(TARGET_CONFIGURE_OPTS) LDSHARED='$(TARGET_CC) -shared' \
	    $(HOST_STAGING_PREFIX)/bin/python2.6 setup.py build; \
	)
	touch $@

#
# This is the build convenience target.
#
bzr-rewrite: $(BZR-REWRITE_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
#$(BZR-REWRITE_BUILD_DIR)/.staged: $(BZR-REWRITE_BUILD_DIR)/.built
#	rm -f $@
#	$(MAKE) -C $(BZR-REWRITE_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
#	touch $@
#
#bzr-rewrite-stage: $(BZR-REWRITE_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/bzr-rewrite
#
$(PY25-BZR-REWRITE_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py25-bzr-rewrite" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(BZR-REWRITE_PRIORITY)" >>$@
	@echo "Section: $(BZR-REWRITE_SECTION)" >>$@
	@echo "Version: $(BZR-REWRITE_VERSION)-$(BZR-REWRITE_IPK_VERSION)" >>$@
	@echo "Maintainer: $(BZR-REWRITE_MAINTAINER)" >>$@
	@echo "Source: $(BZR-REWRITE_SITE)/$(BZR-REWRITE_SOURCE)" >>$@
	@echo "Description: $(BZR-REWRITE_DESCRIPTION)" >>$@
	@echo "Depends: $(PY25-BZR-REWRITE_DEPENDS)" >>$@
	@echo "Conflicts: $(BZR-REWRITE_CONFLICTS)" >>$@

$(PY26-BZR-REWRITE_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: py26-bzr-rewrite" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(BZR-REWRITE_PRIORITY)" >>$@
	@echo "Section: $(BZR-REWRITE_SECTION)" >>$@
	@echo "Version: $(BZR-REWRITE_VERSION)-$(BZR-REWRITE_IPK_VERSION)" >>$@
	@echo "Maintainer: $(BZR-REWRITE_MAINTAINER)" >>$@
	@echo "Source: $(BZR-REWRITE_SITE)/$(BZR-REWRITE_SOURCE)" >>$@
	@echo "Description: $(BZR-REWRITE_DESCRIPTION)" >>$@
	@echo "Depends: $(PY26-BZR-REWRITE_DEPENDS)" >>$@
	@echo "Conflicts: $(BZR-REWRITE_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(BZR-REWRITE_IPK_DIR)$(TARGET_PREFIX)/sbin or $(BZR-REWRITE_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(BZR-REWRITE_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(BZR-REWRITE_IPK_DIR)$(TARGET_PREFIX)/etc/bzr-rewrite/...
# Documentation files should be installed in $(BZR-REWRITE_IPK_DIR)$(TARGET_PREFIX)/doc/bzr-rewrite/...
# Daemon startup scripts should be installed in $(BZR-REWRITE_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??bzr-rewrite
#
# You may need to patch your application to make it use these locations.
#
$(PY25-BZR-REWRITE_IPK): $(BZR-REWRITE_BUILD_DIR)/.built
	rm -rf $(BUILD_DIR)/py25-bzr-rebase_*_$(TARGET_ARCH).ipk
	rm -rf $(PY25-BZR-REWRITE_IPK_DIR) $(BUILD_DIR)/py25-bzr-rewrite_*_$(TARGET_ARCH).ipk
	(cd $(BZR-REWRITE_BUILD_DIR)/2.5; \
	    $(HOST_STAGING_PREFIX)/bin/python2.5 setup.py install --root=$(PY25-BZR-REWRITE_IPK_DIR) --prefix=$(TARGET_PREFIX); \
	)
#	$(STRIP_COMMAND) $(PY25-BZR-REWRITE_IPK_DIR)$(TARGET_PREFIX)/lib/python2.5/site-packages/bzrlib/*.so
	$(MAKE) $(PY25-BZR-REWRITE_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY25-BZR-REWRITE_IPK_DIR)

$(PY26-BZR-REWRITE_IPK): $(BZR-REWRITE_BUILD_DIR)/.built
	rm -rf $(BUILD_DIR)/py26-bzr-rebase_*_$(TARGET_ARCH).ipk
	rm -rf $(PY26-BZR-REWRITE_IPK_DIR) $(BUILD_DIR)/py26-bzr-rewrite_*_$(TARGET_ARCH).ipk
	(cd $(BZR-REWRITE_BUILD_DIR)/2.6; \
	    $(HOST_STAGING_PREFIX)/bin/python2.6 setup.py install --root=$(PY26-BZR-REWRITE_IPK_DIR) --prefix=$(TARGET_PREFIX); \
	)
#	$(STRIP_COMMAND) $(PY26-BZR-REWRITE_IPK_DIR)$(TARGET_PREFIX)/lib/python2.6/site-packages/bzrlib/*.so
	$(MAKE) $(PY26-BZR-REWRITE_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY26-BZR-REWRITE_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
bzr-rewrite-ipk: $(PY25-BZR-REWRITE_IPK) $(PY26-BZR-REWRITE_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
bzr-rewrite-clean:
	-$(MAKE) -C $(BZR-REWRITE_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
bzr-rewrite-dirclean:
	rm -rf $(BUILD_DIR)/$(BZR-REWRITE_DIR) $(BZR-REWRITE_BUILD_DIR)
	rm -rf $(PY25-BZR-REWRITE_IPK_DIR) $(PY25-BZR-REWRITE_IPK)
	rm -rf $(PY26-BZR-REWRITE_IPK_DIR) $(PY26-BZR-REWRITE_IPK)

#
# Some sanity check for the package.
#
bzr-rewrite-check: $(PY25-BZR-REWRITE_IPK) $(PY26-BZR-REWRITE_IPK)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^
