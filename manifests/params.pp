# Class: bareos::params
#
# Set some platform specific paramaters.
#
class bareos::params {

  $file_retention = '45 days'
  $job_retention  = '6 months'
  $autoprune      = 'yes'
  $monitor        = true
  $ssl            = hiera('bareos::params::ssl', false)
  $ssl_dir        = hiera('bareos::params::ssl_dir', '/etc/puppetlabs/puppet/ssl')
  $device_seltype = 'bareos_store_t'

  validate_bool($ssl)

  if $facts['operatingsystem'] in ['RedHat', 'CentOS', 'Fedora', 'Scientific'] {
    $db_type        = hiera('bareos::params::db_type', 'postgresql')
  } else {
    $db_type        = hiera('bareos::params::db_type', 'postgresql')
  }

  $storage          = hiera('bareos::params::storage', $::fqdn)
  $director         = hiera('bareos::params::director', $::fqdn)
  $director_address = hiera('bareos::params::director_address', $director)
  $job_tag          = hiera('bareos::params::job_tag', '')

  case $facts['operatingsystem'] {
    'Ubuntu','Debian': {
      $bareos_director_packages = [ 'bareos-director', "bareos-database-${db_type}", 'bareos-bconsole' ]
      $bareos_director_service  = 'bareos-dir'
      $bareos_director_bin      = '/usr/sbin/bareos-dir'
      $bareos_storage_packages  = [ 'bareos-storage' ]
      $bareos_storage_service   = 'bareos-sd'
      $bareos_storage_bin       = '/usr/sbin/bareos-sd'
      $bareos_client_package    = 'bareos-client'
      $bareos_client_service    = 'bareos-fd'
      $bareos_client_bin        = '/usr/sbin/bareos-fd'
      $conf_dir                 = '/etc/bareos'
      $bareos_dir               = '/etc/bareos/ssl'
      $client_config            = '/etc/bareos/bareos-fd.conf'
      $homedir                  = '/var/lib/bareos'
      $rundir                   = $homedir
      $bareos_user              = 'bareos'
      $bareos_group             = $bareos_user
    }
    'RedHat','CentOS','Fedora','Scientific': {
      $bareos_director_packages = [ 'bareos-director', "bareos-director-${db_type}", 'bareos-console' ]
      $bareos_director_service  = 'bareos-dir'
      $bareos_director_bin      = '/usr/sbin/bareos-dir'
      $bareos_storage_packages  = [ 'bareos-storage' ]
      $bareos_storage_service   = 'bareos-sd'
      $bareos_storage_bin       = '/usr/sbin/bareos-sd'
      $bareos_client_package    = 'bareos-client'
      $bareos_client_service    = 'bareos-fd'
      $bareos_client_bin        = '/usr/sbin/bareos-fd'
      $conf_dir                 = '/etc/bareos'
      $bareos_dir               = '/etc/bareos/ssl'
      $client_config            = '/etc/bareos/bareos-fd.conf'
      $homedir                  = '/var/spool/bareos'
      $rundir                   = '/var/run'
      $bareos_user              = 'bareos'
      $bareos_group             = $bareos_user
    }
    default: { fail("bareos::params has no love for ${facts['operatingsystem']}") }
  }

  $certfile = "${conf_dir}/ssl/${::clientcert}_cert.pem"
  $keyfile  = "${conf_dir}/ssl/${::clientcert}_key.pem"
  $cafile   = "${conf_dir}/ssl/ca.pem"
}
