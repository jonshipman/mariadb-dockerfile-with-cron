#!/bin/bash

source /usr/environment

DB=${MYSQL_DATABASE:-${MARIADB_DATABASE}}

if [ DB != "" ]; then
	cd /backups

	LAST_BACKUP="$(ls -Art | tail -n 1)"
	DBUSER=${MYSQL_USER:-${MARIADB_USER}}
	DBPASS=${MYSQL_PASSWORD:-${MARIADB_PASSWORD}}
	ROOTPASS=${MYSQL_ROOT_PASSWORD:-${MARIADB_ROOT_PASSWORD}}
	USER=${DBUSER:-root}
	PASS=${DBPASS:-${ROOTPASS}}

	if [ -d "/var/lib/mysql/${DB}" ] ; then
		# If the database exists before init then we bail as we already have an image.
		exit 0
	fi

	printf "\n\n** Found /backups/${LAST_BACKUP}, proceeding to import into ${DB} **\n\n" >> /proc/1/fd/1

	if [[ "${LAST_BACKUP}" = *.gz  ]]; then
		gzip -d "${LAST_BACKUP}"
		LAST_BACKUP="$(ls -Art | tail -n 1)"
	fi

	while [ ! -d "/var/lib/mysql/${DB}" ]; do
		sleep 5
	done

	sleep 10

	mysql -u $USER -p"${PASS}" $DB < "${LAST_BACKUP}"

	printf "\n\n** Imported /backups/${LAST_BACKUP} **\n\n" >> /proc/1/fd/1
fi