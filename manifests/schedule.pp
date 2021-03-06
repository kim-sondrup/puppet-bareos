# Define: bareos::schedule
#
# Creates a schedule to which jobs and jobdefs can adhere.
#
define bareos::schedule (
  Array $runs,
  $conf_dir = $bareos::params::conf_dir,
) {

  validate_array($runs)

  concat::fragment { "bareos-schedule-${name}":
    target  => "${conf_dir}/bareos-dir.conf",
    order   => "110-${name}",
    content => template('bareos/schedule.conf.erb'),
  }
}
