class sfptpd (
  Hash $sync_module                              = {},
  String $selection_policy                       = $sfptpd::params::selection_policy,
  Integer $selection_holdoff_interval            = $sfptpd::params::selection_holdoff_interval,
  Optional[String] $selection_policy_rules       = $sfptpd::params::selection_policy_rules,
  String $message_log                            = $sfptpd::params::message_log,
  Optional[String] $stats_log                    = $sfptpd::params::stats_log,
  Optional[String] $json_remote_monitor          = $sfptpd::params::json_remote_monitor,
  Optional[String] $json_stats                   = $sfptpd::params::json_stats,
  Boolean $daemon                                = $sfptpd::params::daemon,
  String $lock                                   = $sfptpd::params::lock,
  Optional[Integer] $sync_interval               = $sfptpd::params::sync_interval,
  Optional[Integer] $local_sync_threshold        = $sfptpd::params::local_sync_threshold,
  String $clock_control                          = $sfptpd::params::clock_control,
  Optional[String] $clock_list                   = $sfptpd::params::clock_list,
  Optional[String] $clock_readonly               = $sfptpd::params::clock_readonly,
  Optional[String] $persistent_clock_correction  = $sfptpd::params::persistent_clock_correction,
  Optional[String] $timestamping_interfaces      = $sfptpd::params::timestamping_interfaces,
  String $timestamping_disable_on_exit           = $sfptpd::params::timestamping_disable_on_exit,
  String $non_solarflare_nics                    = $sfptpd::params::non_solarflare_nics,
  String $pid_filter_p                           = $sfptpd::params::pid_filter_p,
  String $pid_filter_i                           = $sfptpd::params::pid_filter_i,
  Integer $trace_level                           = $sfptpd::params::trace_level,
  String $ptp_mgmt_msgs                          = $sfptpd::params::ptp_mgmt_msgs,
  Integer $ptp_max_foreign_records               = $sfptpd::params::ptp_max_foreign_records,
  String $ptp_uuid_filtering                     = $sfptpd::params::ptp_uuid_filtering,
  String $ptp_domain_filtering                   = $sfptpd::params::ptp_domain_filtering,
  String $package_name                           = $sfptpd::params::package_name,
  String $package_ensure                         = $sfptpd::params::package_ensure,
  String $config_file                            = $sfptpd::params::config_file,
  String $config_file_ensure                     = $sfptpd::params::config_file_ensure,
  String $config_file_owner                      = $sfptpd::params::config_file_owner,
  String $config_file_group                      = $sfptpd::params::config_file_group,
  String $config_file_mode                       = $sfptpd::params::config_file_mode,
  String $config_file_content_template           = $sfptpd::params::config_file_content_template,
  Boolean $manage_service                        = $sfptpd::params::manage_service,
  String $service_name                           = $sfptpd::params::service_name,
  String $service_ensure                         = $sfptpd::params::service_ensure,
  Boolean $service_enable                        = $sfptpd::params::service_enable,
  Boolean $service_hasrestart                    = $sfptpd::params::service_hasrestart,
  Boolean $service_hasstatus                     = $sfptpd::params::service_hasstatus,
  Boolean $manage_logrotate                      = $sfptpd::params::manage_logrotate,
  Optional[String] $time_of_day                  = $sfptpd::params::time_of_day,
) inherits sfptpd::params {
  contain sfptpd::install
  contain sfptpd::config
  contain sfptpd::service

  if ($service_ensure == 'running') {
    Class[sfptpd::config] -> Class[sfptpd::service]
  } else {
    Class[sfptpd::service] -> Class[sfptpd::config]
  }
  if ($package_ensure == 'absent') {
    Class[sfptpd::config] -> Class[sfptpd::install]
  } else {
    Class[sfptpd::install] -> Class[sfptpd::config]
  }
}
