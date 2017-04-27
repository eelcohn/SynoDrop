!/bin/sh

# Package
PACKAGE="eggdrop"
DNAME="Eggdrop"

# Location of configuration files for this package
CFG_PATH="/var/packages/${PACKAGE}/etc/"
PKG_PATH="/var/packages/${PACKAGE}/target/"

# Needed for registering certificates in DSM
CERTIFICATE_PATH="/usr/local/etc/certificate/${DNAME}/${PACKAGE}/"

LOG_FILE="/tmp/${PACKAGE}-sss.log"



echo "$(date +'%c'): Certificate reloader for $DNAME..." >> $LOG_FILE 2>&1
case $1 in
	eggdrop)
		echo "$(date +'%c'): Reloading certificates for $DNAME..." >> $LOG_FILE 2>&1
		/var/packages/${PACKAGE}/scripts/start-stop-status status
		PKG_STATUS=$?
		if [ $PKG_STATUS -eq 0 ]; then
			cp "${CERTIFICATE_PATH}privkey.pem" "${CFG_PATH}cert/" >> ${LOG_FILE} 2>&1
			cp "${CERTIFICATE_PATH}cert.pem" "${CFG_PATH}cert/" >> ${LOG_FILE} 2>&1
			cp "${CERTIFICATE_PATH}chain.pem" "${CFG_PATH}cert/" >> ${LOG_FILE} 2>&1
			cp "${CERTIFICATE_PATH}fullchain.pem" "${CFG_PATH}cert/" >> ${LOG_FILE} 2>&1
			chown -R ${EGGDROP_USER}:${EGGDROP_GROUP} "${CFG_PATH}/cert/" >> ${LOG_FILE} 2>&1

			/var/packages/${PACKAGE}/scripts/start-stop-status restart
		fi
		;;
	*)
		echo "Usage: $0 eggdrop" >&2
		exit 1
		;;
esac

