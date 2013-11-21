class duplicitystandalone(
  $bucket = undef,
  $dest_id = undef,
  $dest_key = undef,
  $folder = undef,
  $cloud = undef,
  $pubkey_id = undef,
  $hour = undef,
  $minute = undef,
  $full_if_older_than = undef,
  $pre_command = undef,
  $remove_older_than = undef,
  $mysqlbackup = undef,
  $mysqlbackuponly = undef,
  $mysqlbackupuser = undef,
  $mysqlbackuppass = undef,
  $mysqlbackupdays = undef,
  $backupdirs = undef,
) {

  include duplicitystandalone::params
  include duplicitystandalone::packages

  if $mysqlbackup {
    $_first_pre_command = "/usr/local/sbin/mysqlbackup.sh && " 
    $mysqlbackupdir = " --include '/var/backup/db' "
    class { 'duplicitystandalone::mysql':
      mysqlbackup 	=> $mysqlbackup,
      mysqlbackupuser 	=> $mysqlbackupuser,
      mysqlbackuppass 	=> $mysqlbackuppass,
      mysqlbackupdays 	=> $mysqlbackupdays,
    }
  }

  $_bucket = $bucket ? {
    undef => $duplicitystandalone::params::bucket,
    default => $bucket
  }

  $_dest_id = $dest_id ? {
    undef => $duplicitystandalone::params::dest_id,
    default => $dest_id
  }

  $_dest_key = $dest_key ? {
    undef => $duplicitystandalone::params::dest_key,
    default => $dest_key
  }

  $_folder = $folder ? {
    undef => $duplicitystandalone::params::folder,
    default => $folder
  }

  $_cloud = $cloud ? {
    undef => $duplicitystandalone::params::cloud,
    default => $cloud
  }

  $_pubkey_id = $pubkey_id ? {
    undef => $duplicitystandalone::params::pubkey_id,
    default => $pubkey_id
  }

  $_hour = $hour ? {
    undef => $duplicitystandalone::params::hour,
    default => $hour
  }

  $_minute = $minute ? {
    undef => $duplicitystandalone::params::minute,
    default => $minute
  }

  $_full_if_older_than = $full_if_older_than ? {
    undef => $duplicitystandalone::params::full_if_older_than,
    default => $full_if_older_than
  }
  
  $_pre_command = $pre_command ? {
    undef => '',
    default => "$pre_command && "
  }

  $_encryption = $_pubkey_id ? {
    undef => '--no-encryption',
    default => "--encrypt-key $_pubkey_id"
  }

  $_remove_older_than = $remove_older_than ? {
    undef   => $duplicitystandalone::params::remove_older_than,
    default => $remove_older_than,
  }

  if !($_cloud in [ 's3', 'cf']) {
    fail('$cloud required and at this time supports s3 for amazon s3 and cf for Rackspace cloud files')
  }

  if !$_bucket {
    fail('You need to define a container/bucket name!')
  }

  $_target_url = $_cloud ? {
    'cf' => "'cf+http://$_bucket'",
    's3' => "'s3+http://$_bucket/$_folder/$name/'"
  }

  $_remove_older_than_command = $_remove_older_than ? {
    undef => '',
    default => " && duplicity remove-older-than $_remove_older_than --force $_target_url"
  }

  if (!$_dest_id or !$_dest_key) {
    fail("You need to set all of your key variables: dest_id, dest_key")
  }

  $environment = $_cloud ? {
    'cf' => ["CLOUDFILES_USERNAME='$_dest_id'", "CLOUDFILES_APIKEY='$_dest_key'", "CLOUDFILES_AUTHURL='https://lon.auth.api.rackspacecloud.com/v1.0'"],
    's3' => ["AWS_ACCESS_KEY_ID='$_dest_id'", "AWS_SECRET_ACCESS_KEY='$_dest_key'"],
  }

  if $mysqlbackuponly {
    cron { $name :
      environment => $environment,
      command     => "/usr/local/sbin/mysqlbackup.sh",
      user        => 'root',
      minute      => $_minute,
      hour        => $_hour,
      }
  } else {
    cron { $name :
      environment => $environment,
      command     => template("duplicitystandalone/file-backup.sh.erb"),
      user        => 'root',
      minute      => $_minute,
      hour        => $_hour,
    }
    file { '/usr/local/sbin/duplicitymanualrun.sh':
      content     => template("duplicitystandalone/duplicitymanualrun.sh.erb"),
      mode	  => '0700',
    }
    file { '/usr/local/sbin/duplicityrestore.sh':
      content     => template("duplicitystandalone/duplicityrestore.sh.erb"),
      mode	  => '0700',
    }
    file { '/usr/local/sbin/duplicitylistfiles.sh':
      content     => template("duplicitystandalone/duplicitylistfiles.sh.erb"),
      mode	  => '0700',
    }
  }
  
  if $_pubkey_id {
    exec { 'duplicity-pgp':
      command => "gpg --keyserver subkeys.pgp.net --recv-keys $_pubkey_id",
      path    => "/usr/bin:/usr/sbin:/bin",
      unless  => "gpg --list-key $_pubkey_id"
    }
  }
}
