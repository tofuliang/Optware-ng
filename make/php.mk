###########################################################
#
# php
#
###########################################################

#
# PHP_VERSION, PHP_SITE and PHP_SOURCE define
# the upstream location of the source code for the package.
# PHP_DIR is the directory which is created when the source
# archive is unpacked.
# PHP_UNZIP is the command used to unzip the source.
# It is usually "zcat" (for .gz) or "bzcat" (for .bz2)
#
PHP_SITE=http://static.php.net/www.php.net/distributions/
PHP_VERSION=7.1.3
PHP_SOURCE=php-$(PHP_VERSION).tar.bz2
PHP_DIR=php-$(PHP_VERSION)
PHP_UNZIP=bzcat
PHP_MAINTAINER=Josh Parsons <jbparsons@ucdavis.edu>
PHP_DESCRIPTION=The php scripting language
PHP_SECTION=net
PHP_PRIORITY=optional
PHP_DEPENDS=bzip2, openssl, zlib, libxml2, libxslt, gdbm, libdb, sqlite
ifeq (openldap, $(filter openldap, $(PACKAGES)))
PHP_DEPENDS+=, cyrus-sasl-libs, openldap-libs
endif
ifeq (libstdc++, $(filter libstdc++, $(PACKAGES)))
PHP_DEPENDS+=, libstdc++
endif

### php host cli is needed for phar extension,
### so we have to build it first
PHP_HOST_BUILD_DIR=$(HOST_BUILD_DIR)/php
PHP_HOST_CLI=$(HOST_STAGING_PREFIX)/bin/php

#
# PHP_IPK_VERSION should be incremented when the ipk changes.
#
PHP_IPK_VERSION=2

#
# PHP_CONFFILES should be a list of user-editable files
#
PHP_CONFFILES=$(TARGET_PREFIX)/etc/php.ini
PHP_FPM_CONFFILES=$(TARGET_PREFIX)/etc/php-fpm.conf $(TARGET_PREFIX)/etc/php-fpm.d/www.conf 

#
# PHP_LOCALES defines which locales get installed
#
PHP_LOCALES=

#
# PHP_CONFFILES should be a list of user-editable files
#PHP_CONFFILES=$(TARGET_PREFIX)/etc/php.conf $(TARGET_PREFIX)/etc/init.d/SXXphp

#
# PHP_PATCHES should list any patches, in the the order in
# which they should be applied to the source code.
#
PHP_PATCHES=\
    $(PHP_SOURCE_DIR)/0013-Add-support-for-use-of-the-system-timezone-database.patch \
    $(PHP_SOURCE_DIR)/0032-Use-system-timezone.patch \
    $(PHP_SOURCE_DIR)/0041-Add-patch-to-remove-build-timestamps-from-generated-.patch \
    $(PHP_SOURCE_DIR)/0042-Remove-W3C-validation-icon-to-not-expose-the-reader-.patch \
    $(PHP_SOURCE_DIR)/1000-fix_membar_producer_link_error_gcc3x.patch \
    $(PHP_SOURCE_DIR)/1001-ext-opcache-fix-detection-of-shm-mmap.patch \
    $(PHP_SOURCE_DIR)/1002-gd-iconv.patch \
    $(PHP_SOURCE_DIR)/1003-Fix-dl-cross-compiling-issue.patch \
    $(PHP_SOURCE_DIR)/1004-disable-phar-command.patch \
    $(PHP_SOURCE_DIR)/1005-fix-asm-constraints-in-aarch64-multiply-macro.patch \
    $(PHP_SOURCE_DIR)/5000-freetype-dir.patch \

#
# If the compilation of the package requires additional
# compilation or linking flags, then list them here.
#
PHP_CPPFLAGS=-I$(STAGING_INCLUDE_DIR)/mysql -I$(STAGING_INCLUDE_DIR)/libxml2 -I$(STAGING_INCLUDE_DIR)/libxslt -I$(STAGING_INCLUDE_DIR)/libexslt -I$(STAGING_INCLUDE_DIR)/freetype2
PHP_LDFLAGS=-ldl -lpthread -lgcc_s

#
# PHP_BUILD_DIR is the directory in which the build is done.
# PHP_SOURCE_DIR is the directory which holds all the
# patches and ipkg control files.
# PHP_IPK_DIR is the directory in which the ipk is built.
# PHP_IPK is the name of the resulting ipk files.
#
# You should not change any of these variables.
#
PHP_BUILD_DIR=$(BUILD_DIR)/php
PHP_SOURCE_DIR=$(SOURCE_DIR)/php

PHP_IPK_DIR=$(BUILD_DIR)/php-$(PHP_VERSION)-ipk
PHP_IPK=$(BUILD_DIR)/php_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_CURL_IPK_DIR=$(BUILD_DIR)/php-curl-$(PHP_VERSION)-ipk
PHP_CURL_IPK=$(BUILD_DIR)/php-curl_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_CLI_IPK_DIR=$(BUILD_DIR)/php-cli-$(PHP_VERSION)-ipk
PHP_CLI_IPK=$(BUILD_DIR)/php-cli_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_FPM_IPK_DIR=$(BUILD_DIR)/php-fpm-$(PHP_VERSION)-ipk
PHP_FPM_IPK=$(BUILD_DIR)/php-fpm_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_GD_IPK_DIR=$(BUILD_DIR)/php-gd-$(PHP_VERSION)-ipk
PHP_GD_IPK=$(BUILD_DIR)/php-gd_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_GMP_IPK_DIR=$(BUILD_DIR)/php-gmp-$(PHP_VERSION)-ipk
PHP_GMP_IPK=$(BUILD_DIR)/php-gmp_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_IMAP_IPK_DIR=$(BUILD_DIR)/php-imap-$(PHP_VERSION)-ipk
PHP_IMAP_IPK=$(BUILD_DIR)/php-imap_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_INTL_IPK_DIR=$(BUILD_DIR)/php-intl-$(PHP_VERSION)-ipk
PHP_INTL_IPK=$(BUILD_DIR)/php-intl_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_LDAP_IPK_DIR=$(BUILD_DIR)/php-ldap-$(PHP_VERSION)-ipk
PHP_LDAP_IPK=$(BUILD_DIR)/php-ldap_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_MBSTRING_IPK_DIR=$(BUILD_DIR)/php-mbstring-$(PHP_VERSION)-ipk
PHP_MBSTRING_IPK=$(BUILD_DIR)/php-mbstring_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_MCRYPT_IPK_DIR=$(BUILD_DIR)/php-mcrypt-$(PHP_VERSION)-ipk
PHP_MCRYPT_IPK=$(BUILD_DIR)/php-mcrypt_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_MYSQLI_IPK_DIR=$(BUILD_DIR)/php-mysqli-$(PHP_VERSION)-ipk
PHP_MYSQLI_IPK=$(BUILD_DIR)/php-mysqli_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_PGSQL_IPK_DIR=$(BUILD_DIR)/php-pgsql-$(PHP_VERSION)-ipk
PHP_PGSQL_IPK=$(BUILD_DIR)/php-pgsql_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_ODBC_IPK_DIR=$(BUILD_DIR)/php-odbc-$(PHP_VERSION)-ipk
PHP_ODBC_IPK=$(BUILD_DIR)/php-odbc_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_XMLRPC_IPK_DIR=$(BUILD_DIR)/php-xmlrpc-$(PHP_VERSION)-ipk
PHP_XMLRPC_IPK=$(BUILD_DIR)/php-xmlrpc_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_ZIP_IPK_DIR=$(BUILD_DIR)/php-zip-$(PHP_VERSION)-ipk
PHP_ZIP_IPK=$(BUILD_DIR)/php-zip_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_BCMATH_IPK_DIR=$(BUILD_DIR)/php-bcmath-$(PHP_VERSION)-ipk
PHP_BCMATH_IPK=$(BUILD_DIR)/php-bcmath_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_BZ2_IPK_DIR=$(BUILD_DIR)/php-bz2-$(PHP_VERSION)-ipk
PHP_BZ2_IPK=$(BUILD_DIR)/php-bz2_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_CALENDAR_IPK_DIR=$(BUILD_DIR)/php-calendar-$(PHP_VERSION)-ipk
PHP_CALENDAR_IPK=$(BUILD_DIR)/php-calendar_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_DBA_IPK_DIR=$(BUILD_DIR)/php-dba-$(PHP_VERSION)-ipk
PHP_DBA_IPK=$(BUILD_DIR)/php-dba_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_EXIF_IPK_DIR=$(BUILD_DIR)/php-exif-$(PHP_VERSION)-ipk
PHP_EXIF_IPK=$(BUILD_DIR)/php-exif_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_OPCACHE_IPK_DIR=$(BUILD_DIR)/php-opcache-$(PHP_VERSION)-ipk
PHP_OPCACHE_IPK=$(BUILD_DIR)/php-opcache_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_OPENSSL_IPK_DIR=$(BUILD_DIR)/php-openssl-$(PHP_VERSION)-ipk
PHP_OPENSSL_IPK=$(BUILD_DIR)/php-openssl_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_PDO_MYSQL_IPK_DIR=$(BUILD_DIR)/php-pdo_mysql-$(PHP_VERSION)-ipk
PHP_PDO_MYSQL_IPK=$(BUILD_DIR)/php-pdo_mysql_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_PDO_PGSQL_IPK_DIR=$(BUILD_DIR)/php-pdo_pgsql-$(PHP_VERSION)-ipk
PHP_PDO_PGSQL_IPK=$(BUILD_DIR)/php-pdo_pgsql_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_SHMOP_IPK_DIR=$(BUILD_DIR)/php-shmop-$(PHP_VERSION)-ipk
PHP_SHMOP_IPK=$(BUILD_DIR)/php-shmop_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_SOCKETS_IPK_DIR=$(BUILD_DIR)/php-sockets-$(PHP_VERSION)-ipk
PHP_SOCKETS_IPK=$(BUILD_DIR)/php-sockets_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_SYSVMSG_IPK_DIR=$(BUILD_DIR)/php-sysvmsg-$(PHP_VERSION)-ipk
PHP_SYSVMSG_IPK=$(BUILD_DIR)/php-sysvmsg_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_SYSVSEM_IPK_DIR=$(BUILD_DIR)/php-sysvsem-$(PHP_VERSION)-ipk
PHP_SYSVSEM_IPK=$(BUILD_DIR)/php-sysvsem_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_SYSVSHM_IPK_DIR=$(BUILD_DIR)/php-sysvshm-$(PHP_VERSION)-ipk
PHP_SYSVSHM_IPK=$(BUILD_DIR)/php-sysvshm_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_XSL_IPK_DIR=$(BUILD_DIR)/php-xsl-$(PHP_VERSION)-ipk
PHP_XSL_IPK=$(BUILD_DIR)/php-xsl_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_ZLIB_IPK_DIR=$(BUILD_DIR)/php-zlib-$(PHP_VERSION)-ipk
PHP_ZLIB_IPK=$(BUILD_DIR)/php-zlib_$(PHP_VERSION)-$(PHP_IPK_VERSION)_$(TARGET_ARCH).ipk

PHP_CONFIGURE_ARGS=
PHP_CONFIGURE_ENV=
PHP_TARGET_IPKS = \
	$(PHP_CURL_IPK) \
	$(PHP_CLI_IPK) \
	$(PHP_FPM_IPK) \
	$(PHP_GD_IPK) \
	$(PHP_GMP_IPK) \
	$(PHP_IMAP_IPK) \
	$(PHP_INTL_IPK) \
	$(PHP_MBSTRING_IPK) \
	$(PHP_MCRYPT_IPK) \
	$(PHP_MYSQLI_IPK) \
	$(PHP_PGSQL_IPK) \
	$(PHP_ODBC_IPK) \
	$(PHP_XMLRPC_IPK) \
	$(PHP_ZIP_IPK) \
	$(PHP_BCMATH_IPK) \
	$(PHP_BZ2_IPK) \
	$(PHP_CALENDAR_IPK) \
	$(PHP_DBA_IPK) \
	$(PHP_EXIF_IPK) \
	$(PHP_OPCACHE_IPK) \
	$(PHP_OPENSSL_IPK) \
	$(PHP_PDO_MYSQL_IPK) \
	$(PHP_PDO_PGSQL_IPK) \
	$(PHP_SHMOP_IPK) \
	$(PHP_SOCKETS_IPK) \
	$(PHP_SYSVMSG_IPK) \
	$(PHP_SYSVSEM_IPK) \
	$(PHP_SYSVSHM_IPK) \
	$(PHP_XSL_IPK) \
	$(PHP_ZLIB_IPK) \

# We need this because openldap does not build on the wl500g.
ifeq (openldap, $(filter openldap, $(PACKAGES)))
PHP_CONFIGURE_ARGS += \
		--with-ldap=shared,$(STAGING_PREFIX) \
		--with-ldap-sasl=$(STAGING_PREFIX)
PHP_CONFIGURE_ENV += LIBS=-lsasl2
PHP_TARGET_IPKS += $(PHP_LDAP_IPK)
endif

ifeq (glibc, $(LIBC_STYLE))
PHP_CONFIGURE_ARGS +=--with-iconv=shared
else
  ifeq (libiconv, $(filter libiconv, $(PACKAGES)))
PHP_CONFIGURE_ARGS +=--with-iconv=shared,$(STAGING_PREFIX)
  else
PHP_CONFIGURE_ARGS +=--without-iconv
  endif
endif

.PHONY: php-source php-unpack php php-stage php-ipk php-clean php-dirclean php-check

#
# Automatically create a ipkg control file
#
$(PHP_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: $(PHP_DESCRIPTION)" >>$@
	@echo "Depends: $(PHP_DEPENDS)" >>$@

$(PHP_CURL_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-curl" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: libcurl extension for php" >>$@
	@echo "Depends: php, libcurl" >>$@

$(PHP_CLI_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-cli" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: The php scripting language, built as an cli module" >>$@
	@echo "Depends: php" >>$@

$(PHP_FPM_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-fpm" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: The php scripting language, built as an fpm module" >>$@
	@echo "Depends: php" >>$@

$(PHP_GD_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-gd" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: libgd extension for php" >>$@
	@echo "Depends: php, libgd" >>$@

$(PHP_GMP_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-gmp" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: libgmp extension for php" >>$@
	@echo "Depends: php, libgmp" >>$@

$(PHP_IMAP_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-imap" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: imap extension for php" >>$@
	@echo "Depends: php, imap-libs, libpam" >>$@

$(PHP_INTL_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-intl" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: intl extension for php" >>$@
	@echo "Depends: php, icu" >>$@

$(PHP_LDAP_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-ldap" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: ldap extension for php" >>$@
	@echo "Depends: php, openldap-libs" >>$@

$(PHP_MBSTRING_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-mbstring" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: mbstring extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_MCRYPT_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-mcrypt" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: mcrypt extension for php" >>$@
	@echo "Depends: php, libmcrypt, libtool" >>$@

$(PHP_MYSQLI_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-mysqli" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: mysqli extensions for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_PGSQL_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-pgsql" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: pgsql extension for php" >>$@
	@echo "Depends: php, postgresql" >>$@

$(PHP_ODBC_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-odbc" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: odbc extension for php" >>$@
	@echo "Depends: php, unixodbc" >>$@

$(PHP_XMLRPC_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-xmlrpc" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: xmlrpc extension for php" >>$@
	@echo "Depends: php, libiconv" >>$@

$(PHP_ZIP_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-zip" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: zip extension for php" >>$@
	@echo "Depends: php, libzip" >>$@

$(PHP_BCMATH_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-bcmath" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: bcmath extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_BZ2_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-bz2" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: bz2 extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_CALENDAR_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-calendar" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: calendar extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_DBA_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-dba" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: dba extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_EXIF_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-exif" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: exif extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_OPCACHE_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-opcache" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: opcache extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_OPENSSL_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-openssl" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: openssl extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_PDO_MYSQL_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-pdo-mysql" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: pdo_mysql extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_PDO_PGSQL_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-pdo-pgsql" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: pdo_pgsql extension for php" >>$@
	@echo "Depends: php, php-pdo" >>$@

$(PHP_SHMOP_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-shmop" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: shmop extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_SOCKETS_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-sockets" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: sockets extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_SYSVMSG_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-sysvmsg" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: sysvmsg extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_SYSVSEM_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-sysvsem" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: sysvsem extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_SYSVSHM_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-sysvshm" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: sysvshm extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_XSL_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-xsl" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: xsl extension for php" >>$@
	@echo "Depends: php" >>$@

$(PHP_ZLIB_IPK_DIR)/CONTROL/control:
	@$(INSTALL) -d $(@D)
	@rm -f $@
	@echo "Package: php-zlib" >>$@
	@echo "Architecture: $(TARGET_ARCH)" >>$@
	@echo "Priority: $(PHP_PRIORITY)" >>$@
	@echo "Section: $(PHP_SECTION)" >>$@
	@echo "Version: $(PHP_VERSION)-$(PHP_IPK_VERSION)" >>$@
	@echo "Maintainer: $(PHP_MAINTAINER)" >>$@
	@echo "Source: $(PHP_SITE)/$(PHP_SOURCE)" >>$@
	@echo "Description: zlib extension for php" >>$@
	@echo "Depends: php" >>$@

#
# This is the dependency on the source code.  If the source is missing,
# then it will be fetched from the site using wget.
#
$(DL_DIR)/$(PHP_SOURCE):
	$(WGET) -P $(@D) $(PHP_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

#
# The source code depends on it existing within the download directory.
# This target will be called by the top level Makefile to download the
# source code's archive (.tar.gz, .bz2, etc.)
#
php-source: $(DL_DIR)/$(PHP_SOURCE) $(PHP_PATCHES)

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
$(PHP_BUILD_DIR)/.configured: $(DL_DIR)/$(PHP_SOURCE) $(PHP_HOST_CLI) $(PHP_PATCHES) make/php.mk
	$(MAKE) bzip2-stage gdbm-stage libcurl-stage libdb-stage libgd-stage libxml2-stage \
		libxslt-stage openssl-stage mysql-stage postgresql-stage freetds-stage \
		unixodbc-stage imap-stage libpng-stage libjpeg-stage libzip-stage icu-stage \
		libpam-stage \
		libgmp-stage sqlite-stage libiconv-stage libmcrypt-stage libtool-stage libtool-host-stage 
ifeq (openldap, $(filter openldap, $(PACKAGES)))
	$(MAKE) openldap-stage cyrus-sasl-stage
endif
ifeq (libstdc++, $(filter libstdc++, $(PACKAGES)))
	$(MAKE) libstdc++-stage
endif
	rm -rf $(BUILD_DIR)/$(PHP_DIR) $(@D)
	$(PHP_UNZIP) $(DL_DIR)/$(PHP_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	mv $(BUILD_DIR)/$(PHP_DIR) $(@D)
	if test -n "$(PHP_PATCHES)"; \
	    then cat $(PHP_PATCHES) | $(PATCH) -p1 -bd $(@D); \
	fi
ifneq ($(HOSTCC), $(TARGET_CC))
	sed -i \
	    -e 's|`$$PG_CONFIG --includedir`|$(STAGING_INCLUDE_DIR)|' \
	    -e 's|`$$PG_CONFIG --libdir`|$(STAGING_LIB_DIR)|' \
	    $(@D)/ext/*pgsql/*.m4
endif
ifeq (glibc, $(LIBC_STYLE))
	sed -i -e 's|/usr/local /usr|$(shell cd $(TARGET_INCDIR)/..; pwd)|' $(@D)/ext/iconv/config.m4
endif

	sed -i -e '/extern int php_string_to_if_index/s/^/#ifndef AI_ADDRCONFIG\n#define AI_ADDRCONFIG 0\n#endif\n/' \
		$(@D)/ext/sockets/sockaddr_conv.c

	(cd $(HOST_STAGING_PREFIX)/share/aclocal; \
		cat libtool.m4 ltoptions.m4 ltversion.m4 ltsugar.m4 \
			lt~obsolete.m4 >> $(@D)/aclocal.m4 \
	)

	(cd $(HOST_STAGING_PREFIX)/share/aclocal; \
		cat libtool.m4 ltoptions.m4 ltversion.m4 ltsugar.m4 \
			lt~obsolete.m4 >> $(@D)/build/libtool.m4 \
	)

	echo 'AC_CONFIG_MACRO_DIR([m4])' >> $(@D)/configure.in

	$(AUTORECONF1.10) -vif $(@D)
	sed -i -e 's/as_fn_error \$$? "cannot run test program while cross compiling/\$$as_echo \$$? "cannot run test program while cross compiling/' \
		-e 's|flock_type=unknown|flock_type=linux\n\$$as_echo "#define HAVE_FLOCK_LINUX /\*\*/" >>confdefs\.h|' \
		-e 's|icu_install_prefix=.*|icu_install_prefix=$(STAGING_PREFIX)|' $(@D)/configure
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		CPPFLAGS="$(STAGING_CPPFLAGS) $(PHP_CPPFLAGS)" \
		LDFLAGS="$(STAGING_LDFLAGS) $(PHP_LDFLAGS)" \
		CFLAGS="$(STAGING_CPPFLAGS) $(PHP_CPPFLAGS) $(STAGING_LDFLAGS) $(PHP_LDFLAGS)" \
		PATH="$(STAGING_DIR)/bin:$$PATH" \
		PHP_LIBXML_DIR=$(STAGING_PREFIX) \
		EXTENSION_DIR=$(TARGET_PREFIX)/lib/php/extensions \
		ac_cv_func_memcmp_working=yes \
		cv_php_mbstring_stdarg=yes \
		STAGING_PREFIX="$(STAGING_PREFIX)" \
		$(PHP_CONFIGURE_ENV) \
		./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--target=$(GNU_TARGET_NAME) \
		--enable-fpm \
		--disable-cgi \
		--disable-phpdbg \
		--prefix=$(TARGET_PREFIX) \
		--with-config-file-path=$(TARGET_PREFIX)/etc \
		--with-config-file-scan-dir=$(TARGET_PREFIX)/etc/php.d \
		--with-pcre-jit \
		--with-openssl=shared,$(STAGING_PREFIX) \
		--with-zlib=shared,$(STAGING_PREFIX) \
		--with-zlib-dir=$(STAGING_PREFIX) \
		--enable-bcmath=shared \
		--with-bz2=shared,$(STAGING_PREFIX) \
		--enable-calendar=shared \
		--with-curl=shared,$(STAGING_PREFIX) \
		--enable-dba=shared \
		--enable-exif=shared \
		--enable-ftp \
		--with-openssl-dir=$(STAGING_PREFIX) \
		--with-gd=shared,$(STAGING_PREFIX) \
		--with-jpeg-dir=$(STAGING_PREFIX) \
		--with-png-dir=$(STAGING_PREFIX) \
		--with-freetype-dir=$(STAGING_PREFIX) \
		--enable-gd-native-ttf \
		--enable-gd-jis-conv \
		--with-gettext=shared,$(STAGING_PREFIX) \
		--with-gmp=shared,$(STAGING_PREFIX) \
		--with-mhash=shared,$(STAGING_PREFIX) \
		--with-imap=shared,$(STAGING_PREFIX) \
		--with-imap-ssl=$(STAGING_PREFIX)/ \
		--enable-intl=shared \
		--with-icu-dir=$(STAGING_PREFIX) \
		--with-ldap=shared,$(STAGING_PREFIX) \
		--with-ldap-sasl=$(STAGING_PREFIX) \
		--enable-mbstring=shared \
		--with-mcrypt=shared,$(STAGING_PREFIX) \
		--with-mysqli=shared,$(STAGING_PREFIX)/bin/mysql_config \
		--enable-embedded-mysqli=shared \
		--enable-pcntl=shared \
		--with-pdo-mysql=shared,$(STAGING_PREFIX) \
		--with-zlib-dir=$(STAGING_PREFIX) \
		--with-pdo-pgsql=shared,$(STAGING_PREFIX) \
		--with-pgsql=shared,$(STAGING_PREFIX) \
		--with-readline=shared,$(STAGING_PREFIX) \
		--enable-shmop=shared \
		--enable-soap=shared \
		--enable-sockets=shared \
		--enable-sysvmsg=shared \
		--enable-sysvsem=shared \
		--enable-sysvshm=shared \
		--enable-wddx=shared \
		--with-libexpat-dir=$(STAGING_PREFIX) \
		--with-libxml-dir=$(STAGING_PREFIX) \
		--with-iconv-dir=$(STAGING_PREFIX) \
		--with-xsl=shared,$(STAGING_PREFIX) \
		--enable-zip=shared \
		--with-zlib-dir=$(STAGING_PREFIX) \
		--with-libzip=$(STAGING_PREFIX) \
		--enable-mysqlnd=shared \
		--without-pear \
	)
	$(PATCH_LIBTOOL) $(@D)/libtool

	echo "#define HAVE_DLOPEN 1" >> $(@D)/main/php_config.h
	echo "#define HAVE_LIBDL 1" >> $(@D)/main/php_config.h
	
	sed -i -e '/#define HAVE_GD_XPM/s|^|//|' \
		-e '/#define HAVE_ATOMIC_H/s|^|//|' $(@D)/main/php_config.h

	sed -i -e 's|\$$(top_builddir)/\$$(SAPI_CLI_PATH)|$(PHP_HOST_CLI)|' \
		-e 's|-Wl,-rpath,$(STAGING_LIB_DIR)|-Wl,-rpath,$(TARGET_PREFIX)/lib|g' \
		-e 's/###      or --detect-prefix//' \
		-e 's|INTL_SHARED_LIBADD =.*|INTL_SHARED_LIBADD = -L$(STAGING_LIB_DIR) -licuuc -licui18n -licuio|' \
		-e 's|^program_prefix =.*|program_prefix =|' $(@D)/Makefile

	# # workaround for /opt/lib/php/extensions/intl.so: undefined symbol: spoofchecker_register_Spoofchecker_class
	for obj in spoofchecker spoofchecker_class spoofchecker_create spoofchecker_main; do \
		(echo "ext/intl/spoofchecker/$${obj}.lo: $(@D)/ext/intl/spoofchecker/$${obj}.c"; \
		 echo "	\$$(LIBTOOL) --mode=compile \$$(CC)  -Wno-write-strings -Iext/intl/ -I$(@D)/ext/intl/ \$$(COMMON_FLAGS) \$$(CFLAGS_CLEAN) \$$(EXTRA_CFLAGS) -fPIC -c $(@D)/ext/intl/spoofchecker/$${obj}.c -o ext/intl/spoofchecker/$${obj}.lo") >> $(@D)/Makefile; \
	done
	sed -i -e '/^shared_objects_intl/s|$$| $(addprefix ext/intl/spoofchecker/,spoofchecker.lo spoofchecker_class.lo spoofchecker_create.lo spoofchecker_main.lo)|' $(@D)/Makefile
	sed -i 's/CFLAGS_CLEAN = -I\/usr\/include/CFLAGS_CLEAN =/g' $(@D)/Makefile
	sed -i 's/$$(LIBTOOL) --mode=compile $$(CC) -I"\/usr\/include"/$$(LIBTOOL) --mode=compile $$(CC)/g' $(@D)/Makefile
	sed -i 's/$$(top_builddir)\/sapi\/cli\/php/$$(PHP_EXECUTABLE)/g' $(@D)/Makefile
	touch $@

php-unpack: $(PHP_BUILD_DIR)/.configured

#
# This builds the actual binary.  You should change the target to refer
# directly to the main binary which is built.
#
$(PHP_BUILD_DIR)/.built: $(PHP_BUILD_DIR)/.configured
	rm -f $@
	$(MAKE) -C $(@D)
	touch $@

#
# You should change the dependency to refer directly to the main binary
# which is built.
#
php: $(PHP_BUILD_DIR)/.built

#
# If you are building a library, then you need to stage it too.
#
$(PHP_BUILD_DIR)/.staged: $(PHP_BUILD_DIR)/.built
	rm -f $@
	$(MAKE) -C $(@D) INSTALL_ROOT=$(STAGING_DIR) program_prefix="" install
	cp $(STAGING_PREFIX)/bin/php-config $(STAGING_DIR)/bin/php-config
	cp $(STAGING_PREFIX)/bin/phpize $(STAGING_DIR)/bin/phpize
	sed -i -e 's!prefix=.*!prefix=$(STAGING_PREFIX)!' $(STAGING_DIR)/bin/phpize
	sed -i -e 's!^prefix=.*!prefix="$(STAGING_PREFIX)"!' $(STAGING_DIR)/bin/php-config
	chmod a+rx $(STAGING_DIR)/bin/phpize
	touch $@

php-stage: $(PHP_BUILD_DIR)/.staged

$(PHP_HOST_CLI): host/.configured $(DL_DIR)/$(PHP_SOURCE)
	rm -rf $(HOST_BUILD_DIR)/$(PHP_DIR) $(PHP_HOST_BUILD_DIR)
	$(PHP_UNZIP) $(DL_DIR)/$(PHP_SOURCE) | tar -C $(HOST_BUILD_DIR) -xvf -
	if test "$(HOST_BUILD_DIR)/$(PHP_DIR)" != "$(PHP_HOST_BUILD_DIR)" ; \
		then mv $(HOST_BUILD_DIR)/$(PHP_DIR) $(PHP_HOST_BUILD_DIR) ; \
	fi
	(cd $(PHP_HOST_BUILD_DIR); \
		./configure \
		--prefix=$(HOST_STAGING_PREFIX) \
		--disable-all \
		--enable-phar \
		--disable-cgi \
	)
	$(MAKE) -C $(PHP_HOST_BUILD_DIR) program_prefix="" install

php-host-stage: $(PHP_HOST_CLI)

php-host-dirclean:
	rm -rf $(HOST_BUILD_DIR)/$(PHP_DIR) $(PHP_HOST_BUILD_DIR)
	rm -f $(PHP_HOST_CLI)

#
# This builds the IPK file.
#
# Binaries should be installed into $(PHP_IPK_DIR)$(TARGET_PREFIX)/sbin or $(PHP_IPK_DIR)$(TARGET_PREFIX)/bin
# (use the location in a well-known Linux distro as a guide for choosing sbin or bin).
# Libraries and include files should be installed into $(PHP_IPK_DIR)$(TARGET_PREFIX)/{lib,include}
# Configuration files should be installed in $(PHP_IPK_DIR)$(TARGET_PREFIX)/etc/php/...
# Documentation files should be installed in $(PHP_IPK_DIR)$(TARGET_PREFIX)/doc/php/...
# Daemon startup scripts should be installed in $(PHP_IPK_DIR)$(TARGET_PREFIX)/etc/init.d/S??php
#
# You may need to patch your application to make it use these locations.
#
# $(PHP_TARGET_IPKS): 
$(PHP_TARGET_IPKS): $(PHP_BUILD_DIR)/.built
	rm -rf $(PHP_IPK_DIR) $(BUILD_DIR)/php_*_$(TARGET_ARCH).ipk
	$(INSTALL) -d $(PHP_IPK_DIR)$(TARGET_PREFIX)/var/lib/php/session
	chmod a=rwx $(PHP_IPK_DIR)$(TARGET_PREFIX)/var/lib/php/session
	$(MAKE) -C $(PHP_BUILD_DIR) INSTALL_ROOT=$(PHP_IPK_DIR) install
	$(STRIP_COMMAND) $(PHP_IPK_DIR)$(TARGET_PREFIX)/bin/php
	$(STRIP_COMMAND) $(PHP_IPK_DIR)$(TARGET_PREFIX)/sbin/php-fpm
	$(STRIP_COMMAND) $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/*.so
	rm -f $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/*.a
	$(INSTALL) -d $(PHP_IPK_DIR)$(TARGET_PREFIX)/etc
	$(INSTALL) -d $(PHP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	$(INSTALL) -m 644 $(PHP_BUILD_DIR)/php.ini-production $(PHP_IPK_DIR)$(TARGET_PREFIX)/etc/php.ini

	### now make php-curl
	rm -rf $(PHP_CURL_IPK_DIR) $(BUILD_DIR)/php-curl_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_CURL_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_CURL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_CURL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/curl.so $(PHP_CURL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/curl.so
	echo extension=curl.so >$(PHP_CURL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/curl.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_CURL_IPK_DIR)
	### now make php-gd
	rm -rf $(PHP_GD_IPK_DIR) $(BUILD_DIR)/php-gd_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_GD_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_GD_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_GD_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/gd.so $(PHP_GD_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/gd.so
	echo extension=gd.so >$(PHP_GD_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/gd.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_GD_IPK_DIR)
	### now make php-gmp
	rm -rf $(PHP_GMP_IPK_DIR) $(BUILD_DIR)/php-gmp_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_GMP_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_GMP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_GMP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/gmp.so $(PHP_GMP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/gmp.so
	echo extension=gmp.so >$(PHP_GMP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/gmp.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_GMP_IPK_DIR)
	### now make php-imap
	rm -rf $(PHP_IMAP_IPK_DIR) $(BUILD_DIR)/php-imap_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_IMAP_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_IMAP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_IMAP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/imap.so $(PHP_IMAP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/imap.so
	echo extension=imap.so >$(PHP_IMAP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/imap.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_IMAP_IPK_DIR)
	### now make php-intl
	rm -rf $(PHP_INTL_IPK_DIR) $(BUILD_DIR)/php-intl_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_INTL_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_INTL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_INTL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/intl.so $(PHP_INTL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/intl.so
	echo extension=intl.so >$(PHP_INTL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/intl.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_INTL_IPK_DIR)
ifeq (openldap, $(filter openldap, $(PACKAGES)))
	### now make php-ldap
	rm -rf $(PHP_LDAP_IPK_DIR) $(BUILD_DIR)/php-ldap_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_LDAP_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_LDAP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_LDAP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/ldap.so $(PHP_LDAP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/ldap.so
	echo extension=ldap.so >$(PHP_LDAP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/ldap.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_LDAP_IPK_DIR)
endif
	### now make php-mbstring
	rm -rf $(PHP_MBSTRING_IPK_DIR) $(BUILD_DIR)/php-mbstring_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_MBSTRING_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_MBSTRING_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_MBSTRING_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/mbstring.so $(PHP_MBSTRING_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/mbstring.so
	echo extension=mbstring.so >$(PHP_MBSTRING_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/mbstring.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_MBSTRING_IPK_DIR)
	### now make php-mcrypt
	rm -rf $(PHP_MCRYPT_IPK_DIR) $(BUILD_DIR)/php-mcrypt_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_MCRYPT_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_MCRYPT_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_MCRYPT_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/mcrypt.so $(PHP_MCRYPT_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/mcrypt.so
	echo extension=mcrypt.so >$(PHP_MCRYPT_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/mcrypt.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_MCRYPT_IPK_DIR)
	### now make php-mysqli
	rm -rf $(PHP_MYSQLI_IPK_DIR) $(BUILD_DIR)/php-mysqli_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_MYSQLI_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_MYSQLI_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_MYSQLI_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/mysqli.so $(PHP_MYSQLI_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/
	echo extension=mysqli.so >$(PHP_MYSQLI_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/mysqli.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_MYSQLI_IPK_DIR)
	### now make php-pdo_mysql
	rm -rf $(PHP_PDO_MYSQL_IPK_DIR) $(BUILD_DIR)/php-pdo_mysql_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_PDO_MYSQL_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_PDO_MYSQL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_PDO_MYSQL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/pdo_mysql.so $(PHP_PDO_MYSQL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/
	echo extension=pdo_mysql.so >>$(PHP_PDO_MYSQL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/pdo_mysql.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_PDO_MYSQL_IPK_DIR)
	### now make php-pgsql
	rm -rf $(PHP_PGSQL_IPK_DIR) $(BUILD_DIR)/php-pgsql_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_PGSQL_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_PGSQL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_PGSQL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/pgsql.so $(PHP_PGSQL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/
	echo extension=pgsql.so >$(PHP_PGSQL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/pgsql.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_PGSQL_IPK_DIR)
	### now make php-pdo_pgsql
	rm -rf $(PHP_PDO_PGSQL_IPK_DIR) $(BUILD_DIR)/php-pdo_pgsql_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_PDO_PGSQL_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_PDO_PGSQL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_PDO_PGSQL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/pdo_pgsql.so $(PHP_PDO_PGSQL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/
	echo extension=pdo_pgsql.so >$(PHP_PDO_PGSQL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/pdo_pgsql.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_PDO_PGSQL_IPK_DIR)
	### now make php-zip
	rm -rf $(PHP_ZIP_IPK_DIR) $(BUILD_DIR)/php-zip_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_ZIP_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_ZIP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_ZIP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/zip.so $(PHP_ZIP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/
	echo extension=zip.so >$(PHP_ZIP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/zip.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_ZIP_IPK_DIR)

	### now make php-bcmath
	rm -rf $(PHP_BCMATH_IPK_DIR) $(BUILD_DIR)/php-bcmath_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_BCMATH_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_BCMATH_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_BCMATH_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/bcmath.so $(PHP_BCMATH_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/bcmath.so
	echo extension=bcmath.so >$(PHP_BCMATH_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/bcmath.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_BCMATH_IPK_DIR)
	### now make php-bz2
	rm -rf $(PHP_BZ2_IPK_DIR) $(BUILD_DIR)/php-bz2_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_BZ2_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_BZ2_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_BZ2_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/bz2.so $(PHP_BZ2_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/bz2.so
	echo extension=bz2.so >$(PHP_BZ2_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/bz2.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_BZ2_IPK_DIR)
	### now make php-calendar
	rm -rf $(PHP_CALENDAR_IPK_DIR) $(BUILD_DIR)/php-calendar_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_CALENDAR_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_CALENDAR_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_CALENDAR_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/calendar.so $(PHP_CALENDAR_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/calendar.so
	echo extension=calendar.so >$(PHP_CALENDAR_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/calendar.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_CALENDAR_IPK_DIR)
	### now make php-dba
	rm -rf $(PHP_DBA_IPK_DIR) $(BUILD_DIR)/php-dba_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_DBA_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_DBA_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_DBA_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/dba.so $(PHP_DBA_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/dba.so
	echo extension=dba.so >$(PHP_DBA_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/dba.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_DBA_IPK_DIR)
	### now make php-exif
	rm -rf $(PHP_EXIF_IPK_DIR) $(BUILD_DIR)/php-exif_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_EXIF_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_EXIF_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_EXIF_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/exif.so $(PHP_EXIF_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/exif.so
	echo extension=exif.so >$(PHP_EXIF_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/exif.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_EXIF_IPK_DIR)
	### now make php-opcache
	rm -rf $(PHP_OPCACHE_IPK_DIR) $(BUILD_DIR)/php-opcache_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_OPCACHE_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_OPCACHE_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_OPCACHE_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/opcache.so $(PHP_OPCACHE_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/opcache.so
	echo zend_extension=opcache.so >$(PHP_OPCACHE_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/opcache.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_OPCACHE_IPK_DIR)
	### now make php-openssl
	rm -rf $(PHP_OPENSSL_IPK_DIR) $(BUILD_DIR)/php-openssl_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_OPENSSL_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_OPENSSL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_OPENSSL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/openssl.so $(PHP_OPENSSL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/openssl.so
	echo extension=openssl.so >$(PHP_OPENSSL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/openssl.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_OPENSSL_IPK_DIR)
	### now make php-shmop
	rm -rf $(PHP_SHMOP_IPK_DIR) $(BUILD_DIR)/php-shmop_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_SHMOP_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_SHMOP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_SHMOP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/shmop.so $(PHP_SHMOP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/shmop.so
	echo extension=shmop.so >$(PHP_SHMOP_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/shmop.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_SHMOP_IPK_DIR)
	### now make php-sockets
	rm -rf $(PHP_SOCKETS_IPK_DIR) $(BUILD_DIR)/php-sockets_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_SOCKETS_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_SOCKETS_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_SOCKETS_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/sockets.so $(PHP_SOCKETS_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/sockets.so
	echo extension=sockets.so >$(PHP_SOCKETS_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/sockets.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_SOCKETS_IPK_DIR)
	### now make php-sysvmsg
	rm -rf $(PHP_SYSVMSG_IPK_DIR) $(BUILD_DIR)/php-sysvmsg_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_SYSVMSG_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_SYSVMSG_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_SYSVMSG_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/sysvmsg.so $(PHP_SYSVMSG_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/sysvmsg.so
	echo extension=sysvmsg.so >$(PHP_SYSVMSG_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/sysvmsg.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_SYSVMSG_IPK_DIR)
	### now make php-sysvsem
	rm -rf $(PHP_SYSVSEM_IPK_DIR) $(BUILD_DIR)/php-sysvsem_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_SYSVSEM_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_SYSVSEM_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_SYSVSEM_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/sysvsem.so $(PHP_SYSVSEM_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/sysvsem.so
	echo extension=sysvsem.so >$(PHP_SYSVSEM_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/sysvsem.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_SYSVSEM_IPK_DIR)
	### now make php-sysvshm
	rm -rf $(PHP_SYSVSHM_IPK_DIR) $(BUILD_DIR)/php-sysvshm_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_SYSVSHM_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_SYSVSHM_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_SYSVSHM_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/sysvshm.so $(PHP_SYSVSHM_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/sysvshm.so
	echo extension=sysvshm.so >$(PHP_SYSVSHM_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/sysvshm.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_SYSVSHM_IPK_DIR)
	### now make php-xsl
	rm -rf $(PHP_XSL_IPK_DIR) $(BUILD_DIR)/php-xsl_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_XSL_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_XSL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_XSL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/xsl.so $(PHP_XSL_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/xsl.so
	echo extension=xsl.so >$(PHP_XSL_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/xsl.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_XSL_IPK_DIR)
	### now make php-zlib
	rm -rf $(PHP_ZLIB_IPK_DIR) $(BUILD_DIR)/php-zlib_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_ZLIB_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_ZLIB_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions
	$(INSTALL) -d $(PHP_ZLIB_IPK_DIR)$(TARGET_PREFIX)/etc/php.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/zlib.so $(PHP_ZLIB_IPK_DIR)$(TARGET_PREFIX)/lib/php/extensions/zlib.so
	echo extension=zlib.so >$(PHP_ZLIB_IPK_DIR)$(TARGET_PREFIX)/etc/php.d/zlib.ini
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_ZLIB_IPK_DIR)

	### now make php-fpm
	rm -rf $(PHP_FPM_IPK_DIR) $(BUILD_DIR)/php-fpm_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_FPM_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_FPM_IPK_DIR)$(TARGET_PREFIX)/sbin
	$(INSTALL) -d $(PHP_FPM_IPK_DIR)$(TARGET_PREFIX)/etc/init.d
	$(INSTALL) -m 755 $(PHP_SOURCE_DIR)/S80php-fpm $(PHP_FPM_IPK_DIR)$(TARGET_PREFIX)/etc/init.d
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/sbin/php-fpm $(PHP_FPM_IPK_DIR)$(TARGET_PREFIX)/sbin/php-fpm
	$(STRIP_COMMAND) $(PHP_FPM_IPK_DIR)$(TARGET_PREFIX)/sbin/php-fpm
	$(INSTALL) -d $(PHP_FPM_IPK_DIR)$(TARGET_PREFIX)/etc/php-fpm.d
	$(INSTALL) -m 644 $(PHP_BUILD_DIR)/sapi/fpm/php-fpm.conf $(PHP_FPM_IPK_DIR)$(TARGET_PREFIX)/etc/php-fpm.conf
	$(INSTALL) -m 644 $(PHP_BUILD_DIR)/sapi/fpm/www.conf $(PHP_FPM_IPK_DIR)$(TARGET_PREFIX)/etc/php-fpm.d/www.conf
	echo $(PHP_FPM_CONFFILES) | sed -e 's/ /\n/g' > $(PHP_FPM_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_FPM_IPK_DIR)
	### now make php-cli
	rm -rf $(PHP_CLI_IPK_DIR) $(BUILD_DIR)/php-cli_*_$(TARGET_ARCH).ipk
	$(MAKE) $(PHP_CLI_IPK_DIR)/CONTROL/control
	$(INSTALL) -d $(PHP_CLI_IPK_DIR)$(TARGET_PREFIX)/bin
	mv $(PHP_IPK_DIR)$(TARGET_PREFIX)/bin/php $(PHP_CLI_IPK_DIR)$(TARGET_PREFIX)/bin/php
	$(STRIP_COMMAND) $(PHP_CLI_IPK_DIR)$(TARGET_PREFIX)/bin/php
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_CLI_IPK_DIR)
	### finally the main ipk
	rm -f $(PHP_IPK_DIR)$(TARGET_PREFIX)/bin/phar
	ln -s phar.phar $(PHP_IPK_DIR)$(TARGET_PREFIX)/bin/phar
	$(MAKE) $(PHP_IPK_DIR)/CONTROL/control
	echo $(PHP_CONFFILES) | sed -e 's/ /\n/g' > $(PHP_IPK_DIR)/CONTROL/conffiles
	cd $(BUILD_DIR); $(IPKG_BUILD) $(PHP_IPK_DIR)

#
# This is called from the top level makefile to create the IPK file.
#
php-ipk: $(PHP_TARGET_IPKS)

#
# This is called from the top level makefile to clean all of the built files.
#
php-clean:
	-$(MAKE) -C $(PHP_BUILD_DIR) clean
php-distclean:
	-$(MAKE) -C $(PHP_BUILD_DIR) distclean

#
# This is called from the top level makefile to clean all dynamically created
# directories.
#
php-dirclean:
	rm -rf $(BUILD_DIR)/$(PHP_DIR) $(PHP_BUILD_DIR) \
	$(PHP_IPK_DIR) $(PHP_IPK) \
	$(PHP_CURL_IPK_DIR) $(PHP_CURL_IPK) \
	$(PHP_CLI_IPK_DIR) $(PHP_CLI_IPK) \
	$(PHP_FPM_IPK_DIR) $(PHP_FPM_IPK) \
	$(PHP_GD_IPK_DIR) $(PHP_GD_IPK) \
	$(PHP_GMP_IPK_DIR) $(PHP_GMP_IPK) \
	$(PHP_IMAP_IPK_DIR) $(PHP_IMAP_IPK) \
	$(PHP_INTL_IPK_DIR) $(PHP_INTL_IPK) \
	$(PHP_MBSTRING_IPK_DIR) $(PHP_MBSTRING_IPK) \
	$(PHP_MCRYPT_IPK_DIR) $(PHP_MCRYPT_IPK) \
	$(PHP_MYSQLI_IPK_DIR) $(PHP_MYSQLI_IPK) \
	$(PHP_PGSQL_IPK_DIR) $(PHP_PGSQL_IPK) \
	$(PHP_ODBC_IPK_DIR) $(PHP_ODBC_IPK) \
	$(PHP_XMLRPC_IPK_DIR) $(PHP_XMLRPC_IPK) \
	$(PHP_ZIP_IPK_DIR) $(PHP_ZIP_IPK) \
	$(PHP_BCMATH_IPK_DIR) $(PHP_BCMATH_IPK) \
	$(PHP_BZ2_IPK_DIR) $(PHP_BZ2_IPK) \
	$(PHP_CALENDAR_IPK_DIR) $(PHP_CALENDAR_IPK) \
	$(PHP_DBA_IPK_DIR) $(PHP_DBA_IPK) \
	$(PHP_EXIF_IPK_DIR) $(PHP_EXIF_IPK) \
	$(PHP_OPCACHE_IPK_DIR) $(PHP_OPCACHE_IPK) \
	$(PHP_OPENSSL_IPK_DIR) $(PHP_OPENSSL_IPK) \
	$(PHP_PDO_MYSQL_IPK_DIR) $(PHP_PDO_MYSQL_IPK) \
	$(PHP_PDO_PGSQL_IPK_DIR) $(PHP_PDO_PGSQL_IPK) \
	$(PHP_SHMOP_IPK_DIR) $(PHP_SHMOP_IPK) \
	$(PHP_SOCKETS_IPK_DIR) $(PHP_SOCKETS_IPK) \
	$(PHP_SYSVMSG_IPK_DIR) $(PHP_SYSVMSG_IPK) \
	$(PHP_SYSVSEM_IPK_DIR) $(PHP_SYSVSEM_IPK) \
	$(PHP_SYSVSHM_IPK_DIR) $(PHP_SYSVSHM_IPK) \
	$(PHP_XSL_IPK_DIR) $(PHP_XSL_IPK) \
	$(PHP_ZLIB_IPK_DIR) $(PHP_ZLIB_IPK) \
	;
ifeq (openldap, $(filter openldap, $(PACKAGES)))
	rm -rf $(PHP_LDAP_IPK_DIR) $(PHP_LDAP_IPK)
endif


#
# Some sanity check for the package.
#
php-check: $(PHP_TARGET_IPKS)
	perl scripts/optware-check-package.pl --target=$(OPTWARE_TARGET) $^

