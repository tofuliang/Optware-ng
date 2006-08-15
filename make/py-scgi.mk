###########################################################
#
# py-scgi
#
###########################################################

#
# PY-SCGI_VERSION, PY-SCGI_SITE and PY-SCGI_SOURCE define
# the upstream location of the source code for the package.
# PY-SCGI_DIR is the directory which is created when the source
# archive is unpacked.
# PY-SCGI_UNZIP is the command used to unzip the source.
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
PY-SCGI_SITE=http://quixote.python.ca/releases
PY-SCGI_VERSION=1.11
PY-SCGI_SOURCE=scgi-$(PY-SCGI_VERSION).tar.gz
PY-SCGI_DIR=scgi-$(PY-SCGI_VERSION)
PY-SCGI_UNZIP=zcat
PY-SCGI_MAINTAINER=Brian Zhou <bzhou@users.sf.net>
PY-SCGI_DESCRIPTION=Server-side implementation of the SCGI protocol.
PY-SCGI_SECTION=misc
PY-SCGI_PRIORITY=optional
PY-SCGI_DEPENDS=python
PY-SCGI_CONFLICTS=

#
# PY-SCGI_IPK_VERSION should be incremented when the ipk changes.
#
PY-SCGI_IPK_VERSION=1

#
# PY-SCGI_CONFFILES should be a list of user-editable files
#PY-SCGI_CONFFILES=/opt/etc/py-scgi.conf /opt/etc/init.d/SXXpy-scgi

#
# PY-SCGI_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
#PY-SCGI_PATCHES=$(PY-SCGI_SOURCE_DIR)/configure.patch

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PY-SCGI_CPPFLAGS=
PY-SCGI_LDFLAGS=

#
# PY-SCGI_BUILD_DIR is the directory in which the build is done.
# PY-SCGI_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PY-SCGI_IPK_DIR is the directory in which the ipk is built.
# PY-SCGI_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PY-SCGI_BUILD_DIR=$(BUILD_DIR)/py-scgi
PY-SCGI_SOURCE_DIR=$(SOURCE_DIR)/py-scgi
PY-SCGI_IPK_DIR=$(BUILD_DIR)/py-scgi-$(PY-SCGI_VERSION)-ipk
PY-SCGI_IPK=$(BUILD_DIR)/py-scgi_$(PY-SCGI_VERSION)-$(PY-SCGI_IPK_VERSION)_$(TARGET_ARCH).ipk

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(PY-SCGI_SOURCE):
	$(WGET) -P $(DL_DIR) $(PY-SCGI_SITE)/$(PY-SCGI_SOURCE)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
py-scgi-source: $(DL_DIR)/$(PY-SCGI_SOURCE) $(PY-SCGI_PATCHES)

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
$(PY-SCGI_BUILD_DIR)/.configured: $(DL_DIR)/$(PY-SCGI_SOURCE) $(PY-SCGI_PATCHES)
#	$(MAKE) somepkg-stage
	rm -rf $(BUILD_DIR)/$(PY-SCGI_DIR) $(PY-SCGI_BUILD_DIR)
	$(PY-SCGI_UNZIP) $(DL_DIR)/$(PY-SCGI_SOURCE) | tar -C $(BUILD_DIR) -xvf -
#	cat $(PY-SCGI_PATCHES) | patch -d $(BUILD_DIR)/$(PY-SCGI_DIR) -p1
	mv $(BUILD_DIR)/$(PY-SCGI_DIR) $(PY-SCGI_BUILD_DIR)
	(cd $(PY-SCGI_BUILD_DIR); \
	    ( \
		echo "[build_ext]"; \
	        echo "include-dirs=$(STAGING_INCLUDE_DIR):$(STAGING_INCLUDE_DIR)/python2.4"; \
	        echo "library-dirs=$(STAGING_LIB_DIR)"; \
	        echo "rpath=/opt/lib"; \
		echo "[build_scripts]"; \
		echo "executable=/opt/bin/python" \
	    ) >> setup.cfg; \
	)
	touch $(PY-SCGI_BUILD_DIR)/.configured

py-scgi-unpack: $(PY-SCGI_BUILD_DIR)/.configured

#
# This builds the actual binary.
#
$(PY-SCGI_BUILD_DIR)/.built: $(PY-SCGI_BUILD_DIR)/.configured
	rm -f $(PY-SCGI_BUILD_DIR)/.built
	(cd $(PY-SCGI_BUILD_DIR); \
	 CC='$(TARGET_CC)' LDSHARED='$(TARGET_CC) -shared' \
	    python2.4 setup.py build; \
	)
	touch $(PY-SCGI_BUILD_DIR)/.built

#
# This is the build convenience target.
#
py-scgi: $(PY-SCGI_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(PY-SCGI_BUILD_DIR)/.staged: $(PY-SCGI_BUILD_DIR)/.built
	rm -f $(PY-SCGI_BUILD_DIR)/.staged
	#$(MAKE) -C $(PY-SCGI_BUILD_DIR) DESTDIR=$(STAGING_DIR) install
	touch $(PY-SCGI_BUILD_DIR)/.staged

py-scgi-stage: $(PY-SCGI_BUILD_DIR)/.staged

#
# This rule creates a control file for ipkg.  It is no longer
# necessary to create a seperate control file under sources/py-scgi
#
$(PY-SCGI_IPK_DIR)/CONTROL/control:
	@install -d $(PY-SCGI_IPK_DIR)/CONTROL
	@rm -f $@
	@echo "Package: py-scgi" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PY-SCGI_PRIORITY)" >>$@
	@echo "Section: $(PY-SCGI_SECTION)" >>$@
	@echo "Version: $(PY-SCGI_VERSION)-$(PY-SCGI_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PY-SCGI_MAINTAINER)" >>$@
	@echo "Source: $(PY-SCGI_SITE)/$(PY-SCGI_SOURCE)" >>$@
	@echo "Description: $(PY-SCGI_DESCRIPTION)" >>$@
	@echo "Depends: $(PY-SCGI_DEPENDS)" >>$@
	@echo "Conflicts: $(PY-SCGI_CONFLICTS)" >>$@

#
# This builds the IPK file.
#
# Binaries should be installed into $(PY-SCGI_IPK_DIR)/opt/sbin or $(PY-SCGI_IPK_DIR)/opt/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PY-SCGI_IPK_DIR)/opt/{lib,include}
# Configuration files should be installed in $(PY-SCGI_IPK_DIR)/opt/etc/py-scgi/...
# Documentation files should be installed in $(PY-SCGI_IPK_DIR)/opt/doc/py-scgi/...
# Daemon startup scripts should be installed in $(PY-SCGI_IPK_DIR)/opt/etc/init.d/S??py-scgi
#
# You may need to patch your application to make it use these locations.
#
$(PY-SCGI_IPK): $(PY-SCGI_BUILD_DIR)/.built
	rm -rf $(PY-SCGI_IPK_DIR) $(BUILD_DIR)/py-scgi_*_$(TARGET_ARCH).ipk
	(cd $(PY-SCGI_BUILD_DIR); \
	 CC='$(TARGET_CC)' LDSHARED='$(TARGET_CC) -shared' \
	    python2.4 setup.py install --root=$(PY-SCGI_IPK_DIR) --prefix=/opt; \
	)
	$(STRIP_COMMAND) $(PY-SCGI_IPK_DIR)/opt/lib/python2.4/site-packages/scgi/*.so
	$(MAKE) $(PY-SCGI_IPK_DIR)/CONTROL/control
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PY-SCGI_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
py-scgi-ipk: $(PY-SCGI_IPK)

#
# This is called from the top level makefile to clean all of the built files.
#
py-scgi-clean:
	-$(MAKE) -C $(PY-SCGI_BUILD_DIR) clean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
py-scgi-dirclean:
	rm -rf $(BUILD_DIR)/$(PY-SCGI_DIR) $(PY-SCGI_BUILD_DIR) $(PY-SCGI_IPK_DIR) $(PY-SCGI_IPK)
