SPK_NAME = eggdrop
SPK_VERS = 1.8.3rc1
SPK_REV = 1
SPK_ICON = src/eggdrop.png

DEPENDS = cross/$(SPK_NAME)
SPK_DEPENDS = tcl

MAINTAINER = Eggheads
MAINTAINER_URL = www.eggheads.org
DISTRIBUTOR = SynoCommunity
DISTRIBUTOR_URL = https://synocommunity.com/
HELPURL = http://eggwiki.org/

DESCRIPTION = Eggdrop is the oldest Internet Relay Chat \(IRC\) bot still in active development. It is a feature rich program designed to be easily used and expanded upon \(using Tcl scripting\) by both novice and advanced IRC users on a variety of hardware and software platforms.
RELOAD_UI = no
DISPLAY_NAME = "Eggdrop"
STARTABLE = yes
CHANGELOG = "First Synology package release for v1.8.3rc1"

HOMEPAGE = http://www.eggheads.org/
LICENSE = GPL

CONF_DIR = src/conf/
HYPERBACKUP_DIR = src/backup/
WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT = src/dsm-control.sh

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = packet_extra_install

include ../../mk/spksrc.spk.mk

.PHONY: packet_extra_install
packet_extra_install:
	install -m 755 -d $(STAGING_DIR)/tools
	install -m 755 src/certificate_reloader.sh $(STAGING_DIR)/tools/certificate_reloader.sh
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/var/log
	install -m 755 -d $(STAGING_DIR)/var/pid
	mkdir $(WORK_DIR)/scripts/
	mkdir $(WORK_DIR)/scripts/backup/
	cp -aR $(HYPERBACKUP_DIR)/* $(WORK_DIR)/scripts/backup/

