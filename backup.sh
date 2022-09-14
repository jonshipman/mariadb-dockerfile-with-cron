#!/bin/bash

source /usr/environment

TODAY="$(date +"%Y_%m_%d_%I_%M_%p")"

MYSQLDB=${MYSQL_DATABASE:-${MARIADB_DATABASE}}
DB=${MYSQLDB:-"--all-databases"}

MYSQLUSER=${MYSQL_USER:-${MARIADB_USER}}
USER=${MYSQLUSER:-root}

MYSQLPASS=${MYSQL_PASSWORD:-${MARIADB_PASSWORD}}
ROOTPASS=${MYSQL_ROOT_PASSWORD:-${MARIADB_ROOT_PASSWORD}}
PASS=${MYSQLPASS:-${ROOTPASS}}

mysqldump -u ${USER} -p"${PASS}" ${DB} | gzip > /backups/${TODAY}.sql.gz

cd /backups
ls -tp | grep -v '/$' | tail -n +8 | xargs -I {} rm -- {}
