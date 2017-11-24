# This toolchain is gcc 7.2.0 on glibc 2.25

GNU_TARGET_NAME = arm-linux
EXACT_TARGET_NAME = arm-buildroot-linux-gnueabihf

DEFAULT_TARGET_PREFIX=/opt
TARGET_PREFIX ?= /opt

LIBC_STYLE=glibc
TARGET_ARCH=arm
TARGET_OS=linux

LIBSTDC++_VERSION=6.0.24

LIBC-DEV_IPK_VERSION=2

GETTEXT_NLS=enable
#NO_BUILTIN_MATH=true
IPV6=yes

CROSS_CONFIGURATION_GCC_VERSION=7.2.0
CROSS_CONFIGURATION_GLIBC_VERSION=2.25

NATIVE_GCC_VERSION=7.2.0
GCC_SOURCE=gcc-$(NATIVE_GCC_VERSION).tar.xz
GCC_UNZIP=xzcat

ifeq ($(HOST_MACHINE), $(filter armv7tel armv7tejl, $(HOST_MACHINE)))

HOSTCC = $(TARGET_CC)
GNU_HOST_NAME = $(GNU_TARGET_NAME)
TARGET_CROSS = $(TARGET_PREFIX)/bin/
TARGET_LIBDIR = $(TARGET_PREFIX)/lib
TARGET_INCDIR = $(TARGET_PREFIX)/include
TARGET_LDFLAGS =
TARGET_CUSTOM_FLAGS=
TARGET_CFLAGS= $(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)

toolchain:

else

HOSTCC = gcc
GNU_HOST_NAME = $(HOST_MACHINE)-pc-linux-gnu
CROSS_CONFIGURATION_GCC=gcc-$(CROSS_CONFIGURATION_GCC_VERSION)
CROSS_CONFIGURATION_GLIBC=glibc-$(CROSS_CONFIGURATION_GLIBC_VERSION)
CROSS_CONFIGURATION=$(CROSS_CONFIGURATION_GCC)-$(CROSS_CONFIGURATION_GLIBC)
TARGET_CROSS_BUILD_DIR = $(BASE_DIR)/toolchain/buildroot-2017.08
TARGET_CROSS_TOP = $(TARGET_CROSS_BUILD_DIR)/output/host
TARGET_CROSS = $(TARGET_CROSS_TOP)/bin/arm-buildroot-linux-gnueabihf-
TARGET_LIBDIR = $(TARGET_CROSS_TOP)/arm-buildroot-linux-gnueabihf/sysroot/usr/lib
TARGET_INCDIR = $(TARGET_CROSS_TOP)/arm-buildroot-linux-gnueabihf/sysroot/usr/include

#	to make feed firmware-independent, we make
#	all packages dependent on glibc-opt by hacking ipkg-build from ipkg-utils,
#	and add following ld flag to hardcode $(TARGET_PREFIX)/lib/ld-linux-armhf.so.3
#	into executables
TARGET_LDFLAGS = -Wl,--dynamic-linker=$(TARGET_PREFIX)/lib/ld-linux-armhf.so.3

TARGET_CUSTOM_FLAGS= -pipe
TARGET_CFLAGS=$(TARGET_OPTIMIZATION) $(TARGET_DEBUGGING) $(TARGET_CUSTOM_FLAGS)

TOOLCHAIN_SITE=http://buildroot.uclibc.org/downloads
TOOLCHAIN_SOURCE=buildroot-2017.08.tar.bz2

GLIBC-OPT_VERSION = 2.25
GLIBC-OPT_IPK_VERSION = 1
GLIBC-OPT_LIBS_SOURCE_DIR = $(TARGET_CROSS_TOP)/arm-buildroot-linux-gnueabihf/sysroot/usr/lib
LIBNSL_SO_DIR = $(TARGET_CROSS_TOP)/arm-buildroot-linux-gnueabihf/sysroot/usr/lib

LIBNSL_VERSION = 2.25
LIBNSL_IPK_VERSION = 1

BUILDROOT-ARMEABIHF_SOURCE_DIR=$(SOURCE_DIR)/buildroot-armeabihf

BUILDROOT-ARMEABIHF_PATCHES=\
$(BUILDROOT-ARMEABIHF_SOURCE_DIR)/glibc-prefix.patch \
$(BUILDROOT-ARMEABIHF_SOURCE_DIR)/toolchain-gccgo.patch \

BUILDROOT-ARMEABIHF_GCC_PATCHES=\
$(wildcard $(BUILDROOT-ARMEABIHF_SOURCE_DIR)/gcc-patches/$(CROSS_CONFIGURATION_GCC_VERSION)/*.patch)

BUILDROOT-ARMEABIHF_GLIBC_PATCHES=\
$(wildcard $(BUILDROOT-ARMEABIHF_SOURCE_DIR)/glibc-patches/*.patch)

toolchain: $(TARGET_CROSS_TOP)/.built

$(DL_DIR)/$(TOOLCHAIN_SOURCE):
	$(WGET) -P $(@D) $(TOOLCHAIN_SITE)/$(@F) || \
	$(WGET) -P $(@D) $(SOURCES_NLO_SITE)/$(@F)

$(TARGET_CROSS_TOP)/.configured: $(DL_DIR)/$(TOOLCHAIN_SOURCE) \
				$(BUILDROOT-ARMEABIHF_SOURCE_DIR)/config \
				$(BUILDROOT-ARMEABIHF_PATCHES) \
				$(BUILDROOT-ARMEABIHF_GCC_PATCHES) \
				$(BUILDROOT-ARMEABIHF_GLIBC_PATCHES) \
				#$(OPTWARE_TOP)/platforms/toolchain-$(OPTWARE_TARGET).mk
	rm -rf $(TARGET_CROSS_TOP) $(TARGET_CROSS_BUILD_DIR)
	mkdir -p $(@D)
	tar -xjvf $(DL_DIR)/$(TOOLCHAIN_SOURCE) -C $(BASE_DIR)/toolchain
	if test -n "$(BUILDROOT-ARMEABIHF_PATCHES)" ; \
		then cat $(BUILDROOT-ARMEABIHF_PATCHES) | \
		$(PATCH) -bd $(TARGET_CROSS_BUILD_DIR) -p1 ; \
	fi
ifneq ($(BUILDROOT-ARMEABIHF_GCC_PATCHES), )
	$(INSTALL) -m 644 $(BUILDROOT-ARMEABIHF_GCC_PATCHES) \
		$(TARGET_CROSS_BUILD_DIR)/package/gcc/$(CROSS_CONFIGURATION_GCC_VERSION)
endif
ifneq ($(BUILDROOT-ARMEABIHF_GLIBC_PATCHES), )
	$(INSTALL) -m 644 $(BUILDROOT-ARMEABIHF_GLIBC_PATCHES) \
		$(TARGET_CROSS_BUILD_DIR)/package/glibc
endif
	sed 's|^BR2_DL_DIR=.*|BR2_DL_DIR="$(DL_DIR)"|' $(BUILDROOT-ARMEABIHF_SOURCE_DIR)/config > $(TARGET_CROSS_BUILD_DIR)/.config
	touch $@

$(TARGET_CROSS_TOP)/.built: $(TARGET_CROSS_TOP)/.configured
	rm -f $@
	$(MAKE) -C $(TARGET_CROSS_BUILD_DIR)
	ln -sf arm-buildroot-linux-gnueabihf-gccgo $(TARGET_CROSS_TOP)/bin/gccgo
	install -m 644 $(BUILDROOT-ARMEABIHF_SOURCE_DIR)/videodev.h $(TARGET_CROSS_TOP)/arm-buildroot-linux-gnueabihf/sysroot/usr/include/linux
	cp -af  $(TARGET_CROSS_TOP)/arm-buildroot-linux-gnueabihf/sysroot/lib/* \
		$(TARGET_CROSS_TOP)/lib/gcc/arm-buildroot-linux-gnueabihf/7.2.0/*.a $(GLIBC-OPT_LIBS_SOURCE_DIR)/
	touch $@

GCC_TARGET_NAME := arm-buildroot-linux-gnueabihf

GCC_CPPFLAGS := -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64

GCC_EXTRA_CONF_ENV := ac_cv_lbl_unaligned_fail=yes ac_cv_func_mmap_fixed_mapped=yes ac_cv_func_memcmp_working=yes ac_cv_have_decl_malloc=yes gl_cv_func_malloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes ac_cv_func_calloc_0_nonnull=yes ac_cv_func_realloc_0_nonnull=yes lt_cv_sys_lib_search_path_spec="" ac_cv_c_bigendian=no

NATIVE_GCC_EXTRA_CONFIG_ARGS=--with-gxx-include-dir=$(TARGET_PREFIX)/include/c++/7.2.0 --disable-__cxa_atexit --with-gnu-ld --disable-libssp --disable-libquadmath --enable-tls --disable-libmudflap --enable-threads --without-isl --without-cloog --disable-decimal-float --with-abi=aapcs-linux --with-cpu=cortex-a9 --with-fpu=vfpv3-d16 --with-float=hard --with-mode=arm --enable-shared --disable-libgomp --with-gmp=$(STAGING_PREFIX) --with-mpfr=$(STAGING_PREFIX) --with-mpc=$(STAGING_PREFIX) --with-default-libstdcxx-abi=gcc4-compatible --with-system-zlib

NATIVE_GCC_ADDITIONAL_DEPS=zlib

NATIVE_GCC_ADDITIONAL_STAGE=zlib-stage

endif
