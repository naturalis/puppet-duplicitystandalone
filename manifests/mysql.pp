class duplicitystandalone::mysql (
  $mysqlbackup = undef,
  $mysqlbackupuser = undef,
  $mysqlbackuppass = undef,
  $mysqlbackupdays = undef,
) 
{
  notice('automysqlbackup backup enabled')


  case $operatingsystem {    
    centos, redhat: {
	$augeaspackagename = 'ruby-augeas'
    }     
    debian, ubuntu: {      
	$augeaspackagename = 'libaugeas-ruby'
    }  
  }

# Create contrib directory in augeas directory for custom mysql lens
  $augeascontribdir = '/usr/share/augeas/lenses/contrib/'
  notice($augeaspackagename)
  file { $augeascontribdir:
    ensure      => directory,
    mode	=> '0700',
    require	=> Package[$augeaspackagename],
  }

# Copy mysql lens in contrib directory
  $mysqlaug =  '/usr/share/augeas/lenses/contrib/mysql.aug'
  file { $mysqlaug:
    ensure 	=> present,
    source 	=> "puppet:///modules/duplicitystandalone/mysql.aug",
    require	=> File[$augeascontribdir],
  }

# Add events parameter in my.cnf for mysqldump, this is needed for automysqlbackup
  augeas { "my.cnf/mysqldump":
    context	=> '/files/etc/my.cnf/mysqldump/',
    load_path 	=> '/usr/share/augeas/lenses/contrib/',
    changes	=> [
	             "clear events",
		   ],
    require 	=> File[$mysqlaug],
  }

  $requireddirs = ['/etc/automysqlbackup','/var/backup','/var/backup/db']

  file { $requireddirs:
    ensure      => directory,
    mode	=> '0700', 
  }

  file { '/etc/automysqlbackup/automysqlbackup.conf':
    content 	=> template('duplicitystandalone/automysqlbackup.conf.erb'),
    mode	=> '0700', 
    require	=> File[$requireddirs],
  }

  file { '/usr/local/sbin/mysqlbackup.sh':
    content 	=> template('duplicitystandalone/mysqlbackup.sh.erb'),
    mode	=> '0700', 
  }

  file { '/usr/bin/automysqlbackup':
    source 	=> 'puppet:///modules/duplicitystandalone/automysqlbackup',
    mode	=> '0700', 
  }
}
