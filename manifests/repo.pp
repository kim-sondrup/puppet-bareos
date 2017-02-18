class bareos::repo (
  String[1] $version   = 'latest',
  Boolean $manage_repo = true,
) {
  if $manage_repo {
    case $facts['operatingsystem'] {
      'Debian': {
        class { '::bareos::repo::debian':
          version => $version,
        }
      }
      default: { }
    }
  }
}
