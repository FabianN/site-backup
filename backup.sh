#!/bin/bash
# Website backup
########################################################################
# Website backup script made by Fabian Norman (fnorman@uoregon.edu,
# FabianN@gmail.com). This script is designed to backup the files and
# the MySQL database for a web site. The backup will be placed into a
# dated tarball. Using this script in any manner other than directed
# is not advisable.
########################################################################

# Location of site files
WWW_DIR="/var/www/"

# MYSQL database info
MYSQL_USER="backup"
MYSQL_PASS="password"
MYSQL_HOST="localhost"
MYSQL_DATABASE="database"

# Location to store the backups
BACKUP_DIR="~/backup/"


# First, lets setup a temp location where the files will go before being tar'd.

if [ -d "/tmp/site_backup_sj2lksdf003l" ]; then
    rm -r /tmp/site_backup_sj2lksdf003l
fi
mkdir -p /tmp/site_backup_sj2lksdf003l/web_files
mkdir -p /tmp/site_backup_sj2lksdf003l/mysql_file

# Now lets copy the web files over to the temp location

rsync -rqa $WWW_DIR /tmp/site_backup_sj2lksdf003l/web_files

# And now lets create a MYSQL dump of the wanted database. Then copy it to the temp location.

mysqldump -u $MYSQL_USER -h $MYSQL_HOST -p$MYSQL_PASSWORD $MYSQL_DATABASE | gzip > /tmp/site_backup_sj2lksdf003l/mysql_file/$MYSQL_DATABASE_backup.sql.gz

# Now lets take all the contents of the temp location and tar it into the desired backup location.

DATE=date +'%F_%R'
cd /tmp/site_backup_sj2lksdf003l/
tar -czf $BACKUP_DIR/$DATE_$MYSQL_DATABASE.tgz ./

