#!/bin/bash
# Website backup v.0.1
########################################################################
# Website backup script made by Fabian Norman (fnorman@uoregon.edu,
# FabianN@gmail.com). This script is designed to backup the files and
# the MySQL database of a web site. The backup will be placed into a
# dated tar. Using this script in any manner other than directed
# is not advisable.
########################################################################

# Location of site files
WWW_DIR="/var/www"

# MYSQL database info
MYSQL_USER="backup"
MYSQL_PASS="password"
MYSQL_HOST="localhost"
MYSQL_DATABASE="database"

# Location to store the backups
BACKUP_DIR="/backup"
# Name of backup file.
BACKUP_NAME="web_site"

if [[ $1 == '--config' ]]; then
	[ -f $2 ] && source $2
fi

# First, lets setup a temp location where the files will go before being tar'd.

if [ -d "/tmp/site_backup_sj2lksdf003l" ]; then
    rm -r /tmp/site_backup_sj2lksdf003l
fi
mkdir -p /tmp/site_backup_sj2lksdf003l/web_files
if (( -n "$MYSQL_USER" )) && (( -n "$MYSQL_PASS" )) && (( -n "$MYSQL_HOST" )) && (( -n "$MYSQL_DATABASE" )); then
	mkdir -p /tmp/site_backup_sj2lksdf003l/mysql_file
fi

# Now lets copy the web files over to the temp location

rsync -rqa $WWW_DIR/ /tmp/site_backup_sj2lksdf003l/web_files

# And now lets create a MYSQL dump of the wanted database. Then copy it to the temp location.

if (( -n "$MYSQL_USER" )) && (( -n "$MYSQL_PASS" )) && (( -n "$MYSQL_HOST" )) && (( -n "$MYSQL_DATABASE" )); then
	MYSQL_FILE=/tmp/site_backup_sj2lksdf003l/mysql_file/$MYSQL_DATABASE'_backup.sql'
	mysqldump -u $MYSQL_USER -h $MYSQL_HOST -p$MYSQL_PASS $MYSQL_DATABASE > $MYSQL_FILE
fi

# Now lets take all the contents of the temp location and tar it into the desired backup location.

if [ ! -d $BACKUP_DIR ]; then
    mkdir -p $BACKUP_DIR
fi
FILE=$BACKUP_DIR/$BACKUP_NAME'_'$(date +%F_%H-%M).tgz
cd /tmp/site_backup_sj2lksdf003l/
tar -czf $FILE ./mysql_file ./web_files
