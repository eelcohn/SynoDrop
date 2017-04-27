PKG_NAME = eggdrop
PKG_VERS = 1.6.21
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = ftp://ftp.eggheads.org/pub/eggdrop/source/1.6
PKG_DIR = $(PKG_NAME)$(PKG_VERS)

BUILD_DEPENDS = cross/zlib cross/tcl

HOMEPAGE = http://www.eggheads.org/
COMMENT = Eggdrop is the oldest Internet Relay Chat \(IRC\) bot still in active development. It is a feature rich program designed to be easily used and expanded upon (using Tcl scripting) by both novice and advanced IRC users on a variety of hardware and software platforms. 
LICENSE = GPL

GNU_CONFIGURE = 1

COMPILE_TARGET = myCompile

CONFIGURE_ARGS=	--prefix=$(STAGING_INSTALL_PREFIX)/ \
		--with-handlen=32 \
		--with-tclinc=$(STAGING_INSTALL_PREFIX)/include/tcl.h \
		--with-tcllib=$(STAGING_INSTALL_PREFIX)/lib/libtcl.so

include ../../mk/spksrc.cross-cc.mk

.PHONY: myCompile
myCompile:
	# Ugly hack 1: prevent redefinition of socklen_t
	# See https://github.com/eggheads/eggdrop/issues/247
	sed -i -- 's/typedef int socklen_t;/\/\/ typedef int socklen_t;/g' $(WORK_DIR)/$(PKG_DIR)/src/eggdrop.h
	@$(RUN) $(MAKE) config

	# Ugly hack 2: make sure the linker finds libz.so
	# See https://github.com/eggheads/eggdrop/issues/250 and https://github.com/eggheads/eggdrop/issues/251
#	cp $(STAGING_INSTALL_PREFIX)lib/libz.so `ls $(WORK_DIR)/tcl8* -d`/unix/
	sed -i -- 's/ -lm -ldl -lnsl  -lpthread/ -lm -ldl -lnsl  -lpthread -lz/g' $(WORK_DIR)/$(PKG_DIR)/Makefile

	# Ugly hack 3: since we're cross-compiling, we do not want to test run the eggdrop executable
	# See https://github.com/eggheads/eggdrop/issues/248
	sed -i -- 's/egg_test_run = EGG_LANGDIR/egg_test_run = echo EGG_LANGDIR/g' $(WORK_DIR)/$(PKG_DIR)/Makefile
	@$(RUN) $(MAKE) eggdrop

	@$(RUN) $(MAKE) install

