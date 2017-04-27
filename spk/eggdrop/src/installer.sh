#!/bin/sh

# Package
PACKAGE="eggdrop"
DNAME="Eggdrop"

# Others
#SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
CFG_PATH="/var/packages/${PACKAGE}/etc/"
CFG_FILE="eggdrop.conf"
USER_FILE="eggdrop.user"
PID_FILE="/tmp/${PACKAGE}.pid"
LOG_FILE="/tmp/${PACKAGE}-sss.log"
EGGDROP_USER="${PACKAGE}"
EGGDROP_GROUP="sc-${PACKAGE}"



preinst ()
{
	exit 0
}

postinst ()
{
	# Create new conf file if we're installing a new package and no conf file exists
	if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
		if [ -f "${CFG_PATH}${CFG_FILE}" ]; then
			echo "$(date +'%c'): Existing conf file detected, using ${CFG_PATH}${CFG_FILE}" >> ${LOG_FILE} 2>&1
			echo "$(date +'%c'): Ignoring settings supplied by the user in the install wizard." >> ${LOG_FILE} 2>&1
			chown -R ${EGGDROP_USER}:${EGGDROP_GROUP} ${CFG_PATH}/*
		else
			echo "$(date +'%c'): Creating new conf file ${CFG_PATH}${CFG_FILE}" >> ${LOG_FILE} 2>&1
			cp ${SYNOPKG_PKGDEST}/eggdrop.conf ${CFG_PATH}${CFG_FILE} >> ${LOG_FILE} 2>&1
			chown ${EGGDROP_USER}:${EGGDROP_GROUP} ${CFG_PATH}${CFG_FILE}

			# Remove die statements so the bot will run
			sed -i -e "s|die \"Please make sure you edit your config file completely.\"||g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|die \"You didn't edit your config file completely like you were told, did you?\"||g" ${CFG_PATH}${CFG_FILE}

			# Edit the configuration according to the wizard
			sed -i -e "s|set username \"lamest\"|set username \"${wizard_bot_username}\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|set nick \"Lamestbot\"|set nick \"${wizard_bot_nickname}\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|set altnick \"Llamab?t\"|set altnick \"${wizard_bot_nickname}?\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|set realname \"/msg LamestBot hello\"|set realname \"/msg ${wizard_bot_nickname} hello\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|set admin \"Lamer <email: lamer@lamest.lame.org>\"|set admin \"${wizard_bot_admin}\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|set network \"I.didn't.edit.my.config.file.net\"|set network \"${wizard_irc_network}\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|  you.need.to.change.this:6667|  ${wizard_irc_network}:${wizard_irc_portnumber}|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|  another.example.com:7000:password||g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|#channel add #lamest|channel add ${wizard_irc_channel}|g" ${CFG_PATH}${CFG_FILE}

			# Set logging options
			mkdir ${CFG_PATH}/log/
			chown ${EGGDROP_USER}:${EGGDROP_GROUP} ${CFG_PATH}/log/
			sed -i -e "s|logfile mco \* \"logs\/eggdrop.log\"|logfile bcmox \* \"${CFG_PATH}log\/eggdrop.log\"\nlogfile jkp ${wizard_irc_channel} \"${CFG_PATH}log\/${wizard_irc_channel}.log\"\nlogfile s ${wizard_irc_channel} \"${CFG_PATH}log\/${wizard_irc_network}.log\"|g" ${CFG_PATH}${CFG_FILE}

			# Set file locations
			sed -i -e "s|set userfile \"LamestBot.user\"|set userfile \"${CFG_PATH}eggdrop.user\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|set chanfile \"LamestBot.chan\"|set chanfile \"${CFG_PATH}eggdrop.chan\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|#set pidfile \"pid.LamestBot\"|set pidfile \"${PID_FILE}\"|g" ${CFG_PATH}${CFG_FILE}
			sed -i -e "s|set notefile \"LamestBot.notes\"|set notefile \"${CFG_PATH}eggdrop.notes\"|g" ${CFG_PATH}${CFG_FILE}
		fi
	fi

		# Set group and permissions on download- and watch dir for DSM5
#		if [ `/bin/get_key_value /etc.defaults/VERSION buildnumber` -ge "4418" ]; then
#			chgrp users ${wizard_download_dir:=/volume1/downloads}
#			chmod g+rw ${wizard_download_dir:=/volume1/downloads}
#			if [ -d "${wizard_watch_dir}" ]; then
#				chgrp users ${wizard_watch_dir}
#				chmod g+rw ${wizard_watch_dir}
#			fi
#			if [ -d "${wizard_incomplete_dir}" ]; then
#				chgrp users ${wizard_incomplete_dir}
#				chmod g+rw ${wizard_incomplete_dir}
#			fi
#		fi
#	fi

	# Add firewall config
#	${SERVICETOOL} --install-configure-file --package ${FWPORTS} >> /dev/null


	exit 0
}

preuninst ()
{
	exit 0
}

postuninst ()
{
	# Remove the config files, user, group, firewall config and temp files (if not upgrading)
	if [ "${SYNOPKG_PKG_STATUS}" == "UNINSTALL" ]; then
		# Remove firewall config
#		${SERVICETOOL} --remove-configure-file --package ${PACKAGE}.sc >> /dev/null

		# Remove conf files if user selected it
		if [ "$pkgwizard_rm_conf" == "true" ]; then
			rm -rf /usr/syno/etc/packages/${PACKAGE}/
		fi

		# Remove temp files
		rm -f ${PID_FILE}
		rm -f ${LOG_FILE}

		# Remove user and group, since DSM6.0 doesn't remove users/groups provided by the conf/privilege file
		synogroup --del ${EGGDROP_GROUP}
		synouser --del ${EGGDROP_USER}
	fi

	exit 0
}

preupgrade ()
{
# Backup of configuration is not needed on DSM6.0+
# ATTENTION!: This code is buggy! Enabling this code will break your DSM!!!

#	# Stop the package
#	${SSS} stop > /dev/null

#	# Save the configuration
#	rm -fr /tmp/${PACKAGE}
#	mkdir -p /tmp/${PACKAGE}
#	mv ${CFG_PATH}/var /tmp/${PACKAGE}/

	exit 0
}

postupgrade ()
{
# Restore of configuration is not needed on DSM6.0+

#	# Restore the configuration files
#	rm -fr ${INSTALL_DIR}/var
#	mv /tmp/${PACKAGE}/var ${CFG_PATH}/

	exit 0
}

