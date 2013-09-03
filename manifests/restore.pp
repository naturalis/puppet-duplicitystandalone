define duplicitystandalone::restore(
  $directory,
  $bucket = undef,
  $dest_id = undef,
  $dest_key = undef,
  $folder = undef,
  $cloud = undef,
  $pubkey_id = undef,
  $post_command = undef,
) {

  include duplicitystandalone::params
  include duplicitystandalone::packages

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

  $_post_command = $post_command ? {
    undef   => '',
    default => "${post_command} && "
  }

  $_encryption = $_pubkey_id ? {
    undef => '--no-encryption',
    default => "--encrypt-key ${_pubkey_id}"
  }

  if !($_cloud in [ 's3', 'cf' ]) {
    fail('$cloud required and at this time supports s3 for amazon s3 and cf for Rackspace cloud files')
  }

  if !$_bucket {
    fail('You need to define a container/bucket name!')
  }

  $_target_url = $_cloud ? {
    'cf' => "'cf+http://${_bucket}'",
    's3' => "'s3+http://${_bucket}/${_folder}/${name}/'"
  }

  if (!$_dest_id or !$_dest_key) {
    fail('You need to set all of your key variables: dest_id, dest_key')
  }

  $environment = $_cloud ? {
    'cf' => ["CLOUDFILES_USERNAME='${_dest_id}'", "CLOUDFILES_APIKEY='${_dest_key}'", "CLOUDFILES_AUTHURL='https://lon.auth.api.rackspacecloud.com/v1.0'"],
    's3' => ["AWS_ACCESS_KEY_ID='${_dest_id}'", "AWS_SECRET_ACCESS_KEY='${_dest_key}'"],
  }

  if $_pubkey_id {
    exec { 'duplicitystandalone-pgp':
      command => "gpg --keyserver subkeys.pgp.net --recv-keys ${_pubkey_id}",
      path    => '/usr/bin:/usr/sbin:/bin',
      unless  => "gpg --list-key ${_pubkey_id}"
    }
  }
}
