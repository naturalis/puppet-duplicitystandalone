class duplicitystandalone::defaults {
  $folder = $::fqdn
  $cloud = 's3'
  $hour = 0
  $minute = 0
  $full_if_older_than = '30D'
  $mysqlbackup = ''
  $mysqlbackuponly = ''
  $mysqlbackupuser = root
  $mysqlbackuppass = ''
  $mysqlbackupdays = 30
  $backupdirs = ['/tmp/backups']
}
