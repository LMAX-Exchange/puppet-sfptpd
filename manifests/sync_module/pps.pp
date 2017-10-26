define sfptpd::sync_module::pps(
  $interface,
  $priority                = undef,
  $sync_threshold          = undef,
  $master_clock_class      = 'locked',
  $master_time_source      = 'gps',
  $master_accuracy         = 'unknown',
  $pps_delay               = undef,
  $pid_filter_p            = '0.05',
  $pid_filter_i            = '0.001',
  $outlier_filter_type     = 'std-dev',
  $outlier_filter_size     = undef,
  $outlier_filter_adaption = '1.0',
  $fir_filter_size         = 4,
) {
  validate_string($interface)
  validate_re($master_clock_class, [ '^locked$', '^holdover$' ],
    "Parameter 'master_clock_class' must be either 'locked' or 'holdover'")
  validate_re($master_time_source, [ '^atomic$', '^gps$', '^ptp$', '^ntp$', '^oscillator$', ],
    "Paramter 'master_time_source' must be one of 'atomic', 'gps', 'ptp', 'ntp' or 'oscillator'")
  validate_re($master_accuracy, [ '^\d+', 'unknown' ],
    "Parameter 'master_accuracy' must be either a number or 'unknown'")
  validate_re($outlier_filter_type, [ '^disabled$', '^std-dev$' ],
    "Parameter 'outlier_filter_type' must be either 'disabled' or 'std-dev'")

  concat::fragment { "pps_${name}":
    target  => $::sfptpd::config_file,
    content => template("${module_name}/pps.erb"),
    order   => 30,
  }
}
