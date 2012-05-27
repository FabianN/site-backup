# Website Backup

This script is for automating the backup of sites, their web files and an associated MySQL database.

## To Use

You can declare the settings in the backup.sh file or you may create a config file to declare all the settings. To run with a config file you want to run : `./backup.sh --config ./path/to/configfile.sh`

To run you need to supply the following settings, either edited in the main backup.sh file or provided via a config file.

### Location of Web files

       WWW_DIR="/var/www"

Provide the location of the files you want backed up, no trailing slashes.

### MySQL info

       MYSQL_USER="backup"
       MYSQL_PASS="password"
       MYSQL_HOST="localhost"
       MYSQL_DATABASE="database"

Replace with the information for the MySQL database.

* *MYSQL_USER* with the username for the MySQL database
* *MYSQL_PASS* with the password for the MySQL user.
* *MYSQL_DATABASE* with the name of the MySQL database.
* *MYSQL_HOST* with the host/location of the MySQL server.

**NOTE:** If you do not use a MySQL database, do not enter anything into **any** of the MySQL settings. Leave them all blank or remove them entirely. You MUST remove them from the main backup.sh file though, even if you are using config files.

### Backup Directory

       BACKUP_DIR="/backup"

Provide the location that you want the backup files to be stored, no trailing slashes.

### Backup File Name

       BACKUP_NAME="web_site"

Set the name of the backup file.

* * *
# Creator, ownership, licensing, etc.

This script was created by Fabian Norman for personal use.

This script is Licensed under the [WTFPL](http://sam.zoy.org/wtfpl/) license. See the COPYING file for the license.
