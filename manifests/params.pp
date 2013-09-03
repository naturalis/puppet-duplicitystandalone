class duplicitystandalone::params(
  $bucket                = undef,
  $dest_id               = undef,
  $dest_key              = undef,
  $cloud                 = $duplicitystandalone::defaults::cloud,
  $pubkey_id             = undef,
  $mysqlbackup		 = $duplicitystandalone::defaults::mysqlbackup,
  $mysqlbackuponly	 = $duplicitystandalone::defaults::mysqlbackuponly,
  $mysqlbackupuser	 = $duplicitystandalone::defaults::mysqlbackupuser,
  $mysqlbackuppass	 = $duplicitystandalone::defaults::mysqlbackuppass,
  $mysqlbackupdays	 = $duplicitystandalone::defaults::mysqlbackupdays,
  $backupdirs		 = $duplicitystandalone::defaults::backupdirs,
  $hour                  = $duplicitystandalone::defaults::hour,
  $minute                = $duplicitystandalone::defaults::minute,
  $full_if_older_than    = $duplicitystandalone::defaults::full_if_older_than,
  $remove_older_than     = undef
) inherits duplicitystandalone::defaults {
}
