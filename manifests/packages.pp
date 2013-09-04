class duplicitystandalone::packages {
  # Install the packages
  case $operatingsystem {
    centos: {
      package {
        ['duplicity','python-boto','perl-GnuPG','python-cloudfiles','ruby-augeas','s3cmd','PackageKit-cron']: ensure => present
      }
     }
    redhat: {
      package {
        ['duplicity','python-boto','perl-GnuPG','python-cloudfiles','ruby-augeas','s3cmd']: ensure => present
      }
     }
    debian, ubuntu: {
      package {
        ['duplicity','python-boto','gnupg','python-rackspace-cloudfiles','libaugeas-ruby','s3cmd']: ensure => present
      }
    }
    default: {
      fail("Unrecognized operating system")
    }
  }
}
