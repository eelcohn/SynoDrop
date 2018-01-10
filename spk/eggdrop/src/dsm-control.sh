#!/bin/sh

# Package
PACKAGE="eggdrop"
DNAME="Eggdrop"

# Others
CFG_PATH="/var/packages/${PACKAGE}/etc/"
CFG_FILE="eggdrop.conf"
USER_FILE="eggdrop.user"
PID_FILE="/tmp/${PACKAGE}.pid"
LOG_FILE="/tmp/${PACKAGE}-sss.log"
EGGDROP_USER="eggdrop"
EGGDROP_GROUP="sc-eggdrop"

# LD_LIBRARY_PATH should be declared in the Tcl package, but we'll do it here as well....
export LD_LIBRARY_PATH="/usr/local/lib"



start_daemon ()
{
	echo "$(date +'%c'): Starting $DNAME..." >> $LOG_FILE 2>&1
        cd $SYNOPKG_PKGDEST

	# Create an user file if none exists
	if [ ! -e ${CFG_PATH}${USER_FILE} ]; then
		echo "$(date +'%c'): Creating new user file ${CFG_PATH}${USER_FILE}" >> ${LOG_FILE} 2>&1
		su $EGGDROP_USER -s /bin/sh -p -c "./eggdrop -m ${CFG_PATH}${CFG_FILE}" >> ${LOG_FILE} 2>&1
	else
		su $EGGDROP_USER -s /bin/sh -p -c "./eggdrop ${CFG_PATH}${CFG_FILE}" >> $LOG_FILE 2>&1
	fi

	if [ "$?" = "0" ]; then
		cd ~/
		echo "$(date +'%c'): ${DNAME} daemon started." >> $LOG_FILE 2>&1
		return 0
	else
		cd ~/
		echo "$(date +'%c'): Cannot start ${DNAME} daemon." >> $LOG_FILE 1>&2
		return 1
	fi
}

stop_daemon ()
{
	echo "$(date +'%c'): Stopping ${DNAME}..." >> $LOG_FILE 2>&1
	kill `cat ${PID_FILE}`
	wait_for_status 1 20 || kill -9 `cat ${PID_FILE}`
	rm -f ${PID_FILE}
}

daemon_status ()
{
	if [ -f ${PID_FILE} ] && kill -0 `cat ${PID_FILE}` > /dev/null 2>&1; then
		return 0
	else
		rm -f ${PID_FILE} >> $LOG_FILE 2>&1;
		return 1
	fi

#	ps cax | grep eggdrop >> $LOG_FILE 2>&1;
#	if [ $? -eq 0 ]; then
#		exit 0
#	else
#		exit 3
#	fi
}



case $1 in
	start)
		if daemon_status; then
			echo "$(date +'%c'): ${DNAME} is already running." >> $LOG_FILE 2>&1
			exit 0
		else
			start_daemon
			exit $?
		fi
		;;

	stop)
		if daemon_status; then
			stop_daemon
			exit $?
		else
			echo "$(date +'%c'): Cannot stop ${DNAME}. ${DNAME} is not running." >> $LOG_FILE 2>&1
			exit 0
		fi
		;;

	status)
		if daemon_status; then
#			echo "$(date +'%c'): ${DNAME} is running." >> $LOG_FILE 2>&1
			exit 0
		else
#			echo "$(date +'%c'): ${DNAME} is not running." >> $LOG_FILE 2>&1
			exit 3
		fi
		;;

	restart)
		echo "$(date +'%c'): Restarting ${DNAME}." >> $LOG_FILE 2>&1
		stop_daemon
		start_daemon
		exit $?
		;;

	log)
		echo ${LOG_FILE}
		;;

	*)
		exit 1
		;;

esac

