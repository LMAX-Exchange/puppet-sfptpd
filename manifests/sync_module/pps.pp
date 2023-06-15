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
  Optional[Integer] $outlier_filter_size                                = undef,
  Float $outlier_filter_adaption                                        = 1.0,
  Integer $fir_filter_size                                              = 4,
  Optional[String] $time_of_day                                         = undef,
) {

  concat::fragment { "pps_${name}":
    target  => $::sfptpd::config_file,
    content => template("${module_name}/pps.erb"),
    order   => 30,
  }
}
