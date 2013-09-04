puppet-duplicitystandalone
===================

Install puppet-base first or make sure puppet is installed and is using a yaml backend for hiera data. 

puppet-base installation: 
https://github.com/naturalis/puppet-base

```
curl https://raw.github.com/naturalis/puppet/master/private/scripts/cloud-puppet.sh > cloud-puppet.sh; chmod +x cloud-puppet.sh;./cloud-puppet.sh base
```
module installation:
```
git clone https://github.com/naturalis/puppet-duplicitystandalone.git /etc/puppet/modules/duplicitystandalone
puppet apply /etc/puppet/modules/duplicitystandalone/tests/init.pp
```

Parameters
-------------
All parameters are read from hiera

Classes
-------------
duplicitystandalone

Dependencies
-------------
Puppet installed with yaml backend. tested with https://github.com/naturalis/puppet-base

Examples
-------------
Hiera yaml, when used with puppet-base then create a file /etc/puppet/hieradata/user-data.yaml with these contents.

```
duplicitystandalone::backmeup: true
duplicitystandalone::backuphour: 2
duplicitystandalone::backupminute: 2
duplicitystandalone::backupdirs:
    - '/home'
    - '/etc'
duplicitystandalone::cloud: 's3'
duplicitystandalone::dest_id: '<s3apiid>'
duplicitystandalone::dest_key: '<s3apikey>'
duplicitystandalone::mysqlbackup: false
duplicitystandalone::mysqlbackuponly: false
duplicitystandalone::mysqlbackupuser: 'root'
duplicitystandalone::mysqlbackuppass: ''
duplicitystandalone::mysqlbackupdays: 120
duplicitystandalone::bucket: 'linuxbackups'
duplicitystandalone::full_if_older_than: '30D'
```

```
backuphour and backupminute     : control crontab schedule setting for the backup script
backupdirs                      : array with which directories to backup, works recursive
cloud                           : Cloud provider type ( s3=amazon, cf=rackspace cloudfiles )
dest_id and dest_key            : API id en Key from cloudprovider
mysqlbackup                     : true enables automysqlbackup integration within the backup, backups are made in /var/backup/db and included in backupdirs
mysqlbackuponly                 : only enables automysqlbackup in /var/backup/db, no duplicity
mysqlbackupuser and pass        : mysql user and password with backup permissions. (user needs : EVENT, SELECT, RELOAD, LOCK TABLES permissions on all databases)
mysqlbackupdays                 : amount of days mysqlbackups are kept, automysqlbackup already has a daily / weekly / monthly /yearly rotation but does not delete the monthly or yearly backups by default. mysqlbackupdays+full_if_older_than is the total available timeperiod backups are kept.
bucket                          : Name of the bucket ( must be created manually from within the cloudproviders website )
full_if_older_than              : Days changes within backup are kept 
```

puppet code
```
class { 'duplicitystandalone': }
```
Result
-------------
Creates crontab entry which starts a scheduled duplicity backup and creates three scripts in /usr/local/sbin for 
easy access to the duplicity backup functionality. 
```
duplicitymanualrun.sh           : Start the backup
duplicitylistfiles.sh           : Lists the available files in the bucket at that moment
duplicityrestore.sh             : Restores files from duplicity
                                  usage: duplicityrestore <files to restore> <time> <destination>
                                  example: duplicityrestore etc/puppet 3D /tmp/restore
                                  if no commandline entries are given then the script runs interactive
                                  and will ask for input
                                  The acceptible time strings are intervals (like "3D64s"), w3-datetime
                                  strings, like "2002-04-26T04:22:01-07:00" (strings like
                                  "2002-04-26T04:22:01" are also acceptable - duplicity will use the
                                  current time zone), or ordinary dates like 2/4/1997 or 2001-04-23
                                  (various combinations are acceptable, but the month always precedes
                                  the day).
```


Limitations
-------------
This module has been built on and tested against Puppet 3.2.4 and higher.

The module has been tested on:
- Ubuntu 12.04LTS, 13.04
- CentOS 6.4 

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

