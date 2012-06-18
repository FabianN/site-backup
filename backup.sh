#!/bin/bash
# Website backup v.0.1
########################################################################
# Website backup script made by Fabian Norman (FabianN AT gmail DOT com)
# This script is designed to backup the files and the MySQL database of
# a web site. The backup will be placed into a dated tar. Using this
# script in any manner other than directed is not advisable.
########################################################################

# Location of site files
WWW_DIR="/var/www"

# Temp file location
TMP="/tmp/site_backup_sj2lksdf003l"

# MYSQL database info
MYSQL_USER="backup"
MYSQL_PASS="password"
MYSQL_HOST="localhost"
MYSQL_DATABASE="database"

# Location to store the backups
BACKUP_DIR="/backup"
# Name of backup file.
BACKUP_NAME="web_site"

# How old should the backup be to be removed? Currently set to 5 days old.
REMOVE="-mtime +5"


if [[ $1 == '--config' ]]; then
	[ -f $2 ] && source $2
fi

# First, lets setup a temp location where the files will go before being tar'd.

if [ -d $TMP ]; then
    rm -r $TMP
fi
mkdir -p $TMP/web_files
if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASS" ] && [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_DATABASE" ]; then
	mkdir -p $TMP/mysql_file
fi

# Now lets copy the web files over to the temp location

rsync -rqa $WWW_DIR/ $TMP/web_files

# And now lets create a MYSQL dump of the wanted database. Then copy it to the temp location.

if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASS" ] && [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_DATABASE" ]; then
	MYSQL_FILE=$TMP'/mysql_file/'$MYSQL_DATABASE'_backup.sql'
	mysqldump -u $MYSQL_USER -h $MYSQL_HOST -p$MYSQL_PASS $MYSQL_DATABASE > $MYSQL_FILE
fi

# Now lets take all the contents of the temp location and tar it into the desired backup location.

if [ ! -d $BACKUP_DIR ]; then
    mkdir -p $BACKUP_DIR
fi
FILE=$BACKUP_DIR/$BACKUP_NAME'_'$(date +%F_%H-%M).tgz
cd $TMP
if [ -n "$MYSQL_USER" ] && [ -n "$MYSQL_PASS" ] && [ -n "$MYSQL_HOST" ] && [ -n "$MYSQL_DATABASE" ]; then
	tar -czf $FILE ./mysql_file ./web_files
else
	tar -czf $FILE ./web_files
fi

# Now remove old backup files
if [ -n "$REMOVE" ]; then
	find $BACKUP_DIR -type f -name '*.tgz' $REMOVE -delete
fi

# Clean up tmp folder
rm -r $TMP
