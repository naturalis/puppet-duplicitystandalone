puppet-duplicitystandalone
===================

Puppet module to install 

For more information using this tool: 

Parameters
-------------
All parameters are read from hiera

Classes
-------------
- 
duplicitystandalone

Dependencies
-------------
- 

Examples
-------------
Hiera yaml

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

puppet code
```
class { 'duplicitystandalone': }
```
Result
-------------
Creates crontab entry which starts a scheduled duplicity backup and creates three scripts in /usr/local/sbin for 
easy access to the duplicity backup functionality. 

duplicitymanualrun.sh           : Start the backup
duplicitylistfiles.sh           : Lists the available files in the bucket at that moment
duplicityrestore.sh             : Restores files from duplicity
                                  usage: duplicityrestore <files to restore> <time> <destination>
                                  example: duplicityrestore etc/puppet 3D /tmp/restore
                                  if no commandline entries are given then the script runs interactive and will a$

                                  The acceptible time strings are intervals (like "3D64s"), w3-datetime
                                  strings, like "2002-04-26T04:22:01-07:00" (strings like
                                  "2002-04-26T04:22:01" are also acceptable - duplicity will use the
                                  current time zone), or ordinary dates like 2/4/1997 or 2001-04-23
                                  (various combinations are acceptable, but the month always precedes
                                  the day).



Limitations
-------------
This module has been built on and tested against Puppet 3.2.4 and higher.

The module has been tested on:
- Ubuntu 12.04LTS, 13.04
- CentOS 6.4 

Authors
-------------
Author Name <hugo.vanduijn@naturalis.nl>

