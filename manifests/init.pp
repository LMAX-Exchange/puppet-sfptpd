class sfptpd(
  $sync_module                  = {},
  $selection_policy             = $sfptpd::params::selection_policy,
  $selection_holdoff_interval   = $sfptpd::params::selection_holdoff_interval,
  $selection_policy_rules       = $sfptpd::params::selection_policy_rules,
  $message_log                  = $sfptpd::params::message_log,
  $stats_log                    = $sfptpd::params::stats_log,
  $json_remote_monitor          = $sfptpd::params::json_remote_monitor,
  $json_stats                   = $sfptpd::params::json_stats,
  $daemon                       = $sfptpd::params::daemon,
  $lock                         = $sfptpd::params::lock,
  $sync_interval                = $sfptpd::params::sync_interval,
  $local_sync_threshold         = $sfptpd::params::local_sync_threshold,
  $clock_control                = $sfptpd::params::clock_control,
  $clock_list                   = $sfptpd::params::clock_list,
  $persistent_clock_correction  = $sfptpd::params::persistent_clock_correction,
  $timestamping_interfaces      = $sfptpd::params::timestamping_interfaces,
  $timestamping_disable_on_exit = $sfptpd::params::timestamping_disable_on_exit,
  $non_solarflare_nics          = $sfptpd::params::non_solarflare_nics,
  $pid_filter_p                 = $sfptpd::params::pid_filter_p,
  $pid_filter_i                 = $sfptpd::params::pid_filter_i,
  $trace_level                  = $sfptpd::params::trace_level,
  $ptp_mgmt_msgs                = $sfptpd::params::ptp_mgmt_msgs,
  $ptp_max_foreign_records      = $sfptpd::params::ptp_max_foreign_records,
  $ptp_uuid_filtering           = $sfptpd::params::ptp_uuid_filtering,
  $ptp_domain_filtering         = $sfptpd::params::ptp_domain_filtering,
  $package_name                 = $sfptpd::params::package_name,
  $package_ensure               = $sfptpd::params::package_ensure,
  $config_file                  = $sfptpd::params::config_file,
  $config_file_ensure           = $sfptpd::params::config_file_ensure,
  $config_file_owner            = $sfptpd::params::config_file_owner,
  $config_file_group            = $sfptpd::params::config_file_group,
  $config_file_mode             = $sfptpd::params::config_file_mode,
  $config_file_content_template = $sfptpd::params::config_file_content_template,
  $manage_service               = $sfptpd::params::manage_service,
  $service_name                 = $sfptpd::params::service_name,
  $service_ensure               = $sfptpd::params::service_ensure,
  $service_enable               = $sfptpd::params::service_enable,
  $service_hasrestart           = $sfptpd::params::service_hasrestart,
  $service_hasstatus            = $sfptpd::params::service_hasstatus,
  $manage_logrotate             = $sfptpd::params::manage_logrotate,
) inherits sfptpd::params {
  validate_hash($sync_module)
  validate_re($selection_policy, [ '^automatic$', '^manual', '^initial-manual-instance' ],
    "Parameter 'selection_policy' must be one of 'automatic', or start with 'manual' or 'initial-manual-instance'")
  validate_integer($selection_holdoff_interval)
  validate_string($selection_policy_rules)
  validate_string($message_log)
  validate_string($stats_log)
  validate_string($json_remote_monitor)
  validate_string($json_stats)
  validate_bool($daemon)
  validate_re($lock, [ '^on$', '^off$' ], "Parameter 'lock' must be 'on' or 'off'")
  if ($sync_interval) {
    validate_integer($sync_interval)
  }
  validate_string($local_sync_threshold)
  validate_re($clock_control, [ '^slew-and-step$', '^step-at-startup$', '^no-step$', '^no-adjust$', '^step-forward$' ],
    "Parameter 'clock_control' must be one of 'slew-and-step', 'step-at-startup', 'no-step', 'no-adjust' or 'step-forward'")
  validate_string($clock_list)
  validate_re($persistent_clock_correction, [ '^on$', '^off$' ],
    "Parameter 'persistent_clock_correction' must be 'on' or 'off'")
  validate_string($timestamping_interfaces)
  validate_re($timestamping_disable_on_exit, [ '^on$', '^off$' ],
    "Parameter 'timestamping_disable_on_exit' must be 'on' or 'off'")
  validate_re($non_solarflare_nics, [ '^on$', '^off$' ],
    "Parameter 'non_solarflare_nics' must be 'on' or 'off'")
  validate_integer($trace_level)

  #Generic PTP option validation
  validate_re($ptp_mgmt_msgs, [ '^disabled$', '^read-only$' ],
    "Parameter 'ptp_mgmt_msgs' must be 'disabled' or 'read-only'")
  validate_integer($ptp_max_foreign_records)
  validate_re($ptp_uuid_filtering, [ '^on$', '^off$' ],
    "Parameter 'ptp_uuid_filtering' must be 'on' or 'off'")
  validate_re($ptp_domain_filtering, [ '^on$', '^off$' ],
    "Parameter 'ptp_domain_filtering' must be 'on' or 'off'")

  validate_string($package_name)
  validate_string($package_ensure)
  validate_string($service_name)
  validate_string($config_file)
  validate_string($config_file_owner)
  validate_string($config_file_group)
  validate_string($config_file_mode)
  validate_string($config_file_content_template)
  validate_string($service_ensure)
  if ! ($service_ensure in [ 'running', 'stopped' ]) {
    fail("Parameter 'service_ensure' must be 'running' or 'stopped'")
  }
  validate_bool($manage_service)
  validate_bool($service_enable)
  validate_bool($service_hasrestart)
  validate_bool($service_hasstatus)
  validate_bool($manage_logrotate)

  contain ::sfptpd::install
  contain ::sfptpd::config
  contain ::sfptpd::service

  if ($service_ensure == 'running') {
    Class[::sfptpd::config] -> Class[::sfptpd::service]
  } else {
    Class[::sfptpd::service] -> Class[::sfptpd::config]
  }
  if ($package_ensure == 'absent') {
    Class[::sfptpd::config] -> Class[::sfptpd::install]
  } else {
    Class[::sfptpd::install] -> Class[::sfptpd::config]
  }
}
