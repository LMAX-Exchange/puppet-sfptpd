class sfptpd(
  $sync_mode                    = $sfptpd::params::sync_mode,
  $interface                    = $sfptpd::params::interface,
  $message_log                  = $sfptpd::params::message_log,
  $stats_log_enable             = $sfptpd::params::stats_log_enable,
  $stats_log_file               = $sfptpd::params::stats_log_file,
  $daemon                       = $sfptpd::params::daemon,
  $lock                         = $sfptpd::params::lock,
  $clock_control                = $sfptpd::params::clock_control,
  $persistent_clock_correction  = $sfptpd::params::persistent_clock_correction,
  $timestamping_interfaces      = $sfptpd::params::timestamping_interfaces,
  $timestamping_disable_on_exit = $sfptpd::params::timestamping_disable_on_exit,
  $trace_level                  = $sfptpd::params::trace_level,
  $ptp_mode                     = $sfptpd::params::ptp_mode,
  $ptp_stats                    = $sfptpd::params::ptp_stats,
  $ptp_pkt_dump                 = $sfptpd::params::ptp_pkt_dump,
  $ptp_pps_log                  = $sfptpd::params::ptp_pps_log,
  $pps_delay                    = $sfptpd::params::pps_delay,
  $ptp_delay_discard_threshold  = $sfptpd::params::ptp_delay_discard_threshold,
  $ptp_tx_latency               = $sfptpd::params::ptp_tx_latency,
  $ptp_rx_latency               = $sfptpd::params::ptp_rx_latency,
  $ptp_network_mode             = $sfptpd::params::ptp_network_mode,
  $ptp_ttl                      = $sfptpd::params::ptp_ttl,
  $ptp_utc_valid_handling       = $sfptpd::params::ptp_utc_valid_handling,
  $ptp_domain                   = $sfptpd::params::ptp_domain,
  $ptp_mgmt_msgs                = $sfptpd::params::ptp_mgmt_msgs,
  $ptp_timing_acl_permit        = $sfptpd::params::ptp_timing_acl_permit,
  $ptp_timing_acl_deny          = $sfptpd::params::ptp_timing_acl_deny,
  $ptp_timing_acl_order         = $sfptpd::params::ptp_timing_acl_order,
  $ptp_mgmt_acl_permit          = $sfptpd::params::ptp_mgmt_acl_permit,
  $ptp_mgmt_acl_deny            = $sfptpd::params::ptp_mgmt_acl_deny,
  $ptp_mgmt_acl_order           = $sfptpd::params::ptp_mgmt_acl_order,
  $ptp_announce_timeout         = $sfptpd::params::ptp_announce_timeout,
  $ptp_sync_pkt_timeout         = $sfptpd::params::ptp_sync_pkt_timeout,
  $ptp_delayreq_interval        = $sfptpd::params::ptp_delayreq_interval,
  $ptp_delayresp_timeout        = $sfptpd::params::ptp_delayresp_timeout,
  $ptp_max_foreign_records      = $sfptpd::params::ptp_max_foreign_records,
  $ptp_uuid_filtering           = $sfptpd::params::ptp_uuid_filtering,
  $ptp_domain_filtering         = $sfptpd::params::ptp_domain_filtering,
  $ptp_trace                    = $sfptpd::params::ptp_trace,
  $freerun_mode                 = $sfptpd::params::freerun_mode,
  $ntp_mode                     = $sfptpd::params::ntp_mode,
  $ntp_poll_interval            = $sfptpd::params::ntp_poll_interval,
  $ntp_key                      = $sfptpd::params::ntp_key,
  $package_name                 = $sfptpd::params::package_name,
  $package_ensure               = $sfptpd::params::package_ensure,
  $service_name                 = $sfptpd::params::service_name,
  $config_file                  = $sfptpd::params::config_file,
  $config_file_owner            = $sfptpd::params::config_file_owner,
  $config_file_group            = $sfptpd::params::config_file_group,
  $config_file_mode             = $sfptpd::params::config_file_mode,
  $config_file_content_template = $sfptpd::params::config_file_content_template,
  $service_name                 = $sfptpd::params::service_name,
  $service_ensure               = $sfptpd::params::service_ensure,
  $service_ensure_force_undef   = $sfptpd::params::service_ensure_force_undef,
  $service_enable               = $sfptpd::params::service_enable,
  $service_hasrestart           = $sfptpd::params::service_hasrestart,
  $service_hasstatus            = $sfptpd::params::service_hasstatus,
  $manage_init_script           = $sfptpd::params::manage_init_script,
  $manage_logrotate             = true,
) inherits sfptpd::params {
  validate_string($sync_mode)
  if ! ($sync_mode in [ 'ptp', 'freerun' ]) {
    fail("Parameter 'sync_mode' must be 'ptp' or 'freerun'")
  }
  validate_string($interface)
  validate_string($message_log)
  validate_string($stats_log)
  validate_bool($daemon)
  validate_string($lock)
  if ! ($lock in [ 'on', 'off' ]) {
    fail("Parameter 'lock' must be 'on' or 'off'")
  }
  validate_string($clock_control)
  if ! ($clock_control in [ 'slew-and-step', 'step-at-startup', 'no-step', 'no-adjust', 'step-forward' ]) {
    fail("Parameter 'clock_control' must be one of: 'slew-and-step', 'step-at-startup', 'no-step', 'no-adjust', 'step-forward'")
  }
  validate_string($persistent_clock_correction)
  if ! ($persistent_clock_correction in [ 'on', 'off' ]) {
    fail("Parameter 'persistent_clock_correction' must be 'on' or 'off'")
  }
  validate_string($freerun_mode)
  if ! ($freerun_mode in [ 'nic', 'ntp' ]) {
    fail("Parameter 'freerun_mode' must be 'nic' or 'ntp'")
  }
  validate_string($ntp_mode)
  if ! ($ntp_mode in ['off', 'read-only', 'control' ]) {
    fail("Parameter 'ntp_mode' must be one of: 'off', 'read-only', 'control'")
  }
  validate_integer($ntp_poll_interval, undef, 1)
  validate_string($ptp_mode)
  validate_bool($ptp_pkt_dump)
  validate_bool($ptp_pps_log)
  validate_integer($pps_delay, undef, 0)
  validate_integer($ptp_delay_discard_threshold)
  validate_integer($ptp_tx_latency)
  validate_integer($ptp_rx_latency)
  validate_string($ptp_network_mode)
  if ! ($ptp_network_mode in [ 'multicast', 'hybrid' ]) {
    fail("Parameter 'ptp_network_mode' must be 'multicast' or 'hybrid'")
  }
  validate_string($ptp_utc_valid_handling)
  if ! ($ptp_utc_valid_handling in [ 'default', 'ignore', 'prefer', 'require' ]) {
    fail("Parameter 'ptp_utc_valid_handling' must be one of: 'default', 'ignore', 'prefer', 'require'")
  }
  validate_integer($ptp_domain)
  validate_string($ptp_mgmt_msgs)
  if ! ($ptp_mgmt_msgs in [ 'disabled', 'read-only' ]) {
    fail("Parameter 'ptp_mgmt_msgs' must be 'disabled' or 'read-only'")
  }
  validate_integer($ptp_announce_timeout)
  validate_integer($ptp_sync_pkt_timeout)
  validate_integer($ptp_delayreq_interval)
  validate_integer($ptp_delayresp_timeout)
  validate_integer($ptp_max_foreign_records)
  validate_string($ptp_uuid_filtering)
  if ! ($ptp_uuid_filtering in [ 'on', 'off' ]) {
    fail("Parameter 'ptp_uuid_filtering' must be 'on' or 'off'")
  }
  validate_string($ptp_domain_filtering)
  if ! ($ptp_domain_filtering in ['on', 'off']) {
    fail("Parameter 'ptp_domain_filtering' must be 'on' or 'off'")
  }
  validate_integer($ptp_trace)

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
  validate_bool($service_ensure_force_undef)
  validate_bool($service_enable)
  validate_bool($service_hasrestart)
  validate_bool($service_hasstatus)
  validate_bool($manage_init_script)

  contain ::sfptpd::install
  contain ::sfptpd::config
  contain ::sfptpd::service

  Class[::sfptpd::install] ->
    Class[::sfptpd::config] ->
    Class[::sfptpd::service]
}
