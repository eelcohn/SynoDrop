PKG_NAME = eggdrop
PKG_VERS = 1.8.4
PKG_EXT = tar.gz
PKG_DIST_NAME = $(PKG_NAME)-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = https://ftp.eggheads.org/pub/eggdrop/source/$(cut -f 1,3 -d '.' $(PKG_VERS))
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

BUILD_DEPENDS = cross/zlib cross/tcl cross/openssl

HOMEPAGE = http://www.eggheads.org/
COMMENT = Eggdrop is the oldest Internet Relay Chat \(IRC\) bot still in active development. It is a feature rich program designed to be easily used and expanded upon (using Tcl scripting) by both novice and advanced IRC users on a variety of hardware and software platforms. 
LICENSE = GPL

GNU_CONFIGURE = 1

PRE_CONFIGURE_TARGET = myPreConfigure
COMPILE_TARGET = myCompile

CONFIGURE_ARGS  = --prefix=$(STAGING_INSTALL_PREFIX)/
CONFIGURE_ARGS += --with-handlen=32
CONFIGURE_ARGS += --enable-tls
CONFIGURE_ARGS += --enable-ipv6
CONFIGURE_ARGS += --with-tclinc=$(STAGING_INSTALL_PREFIX)/include/tcl.h
CONFIGURE_ARGS += --with-tcllib=$(STAGING_INSTALL_PREFIX)/lib/libtcl.so
CONFIGURE_ARGS += --with-sslinc=$(STAGING_INSTALL_PREFIX)/include/openssl/
CONFIGURE_ARGS += --with-ssllib=$(STAGING_INSTALL_PREFIX)/
ADDITIONAL_LDFLAGS = "-Wl,-rpath,/var/packages/tcl/target/lib"

include ../../mk/spksrc.cross-cc.mk

.PHONY: myPreConfigure
myPreConfigure:
	# Make sure that the Eggdrop configure script uses the provided command line switches
	rm $(STAGING_INSTALL_PREFIX)/lib/tclConfig.sh

.PHONY: myCompile
myCompile:
	@$(RUN) $(MAKE) config
	@$(RUN) $(MAKE) eggdrop DEST=$(STAGING_INSTALL_PREFIX)

