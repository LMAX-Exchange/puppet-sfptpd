# sfptpd::sync_module::pps
define sfptpd::sync_module::pps(
  String $interface,
  Optional[Integer] $priority                                           = undef,
  Optional[Integer] $sync_threshold                                     = undef,
  Enum['locked', 'holdover'] $master_clock_class                        = 'locked',
  Enum['atomic', 'gps', 'ptp', 'ntp', 'oscillator'] $master_time_source = 'gps',
  Variant[Integer[0], Enum['unknown']] $master_accuracy                 = 'unknown',
  Optional[Integer] $pps_delay                                          = undef,
  Float $pid_filter_p                                                   = 0.05,
  Float $pid_filter_i                                                   = 0.001,
  Enum['disabled', 'std-dev'] $outlier_filter_type                      = 'std-dev',
  Integer[5, 30] $outlier_filter_size                                   = 30,
  Float[0.0, 1.0] $outlier_filter_adaption                              = 1.0,
  Integer[1, 128] $fir_filter_size                                      = 4,
) {

  concat::fragment { "pps_${name}":
    target  => $::sfptpd::config_file,
    content => template("${module_name}/pps.erb"),
    order   => 30,
  }
}
