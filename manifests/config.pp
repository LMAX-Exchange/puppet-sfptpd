class sfptpd::config (
  Hash $sync_module                              = {},
  String $selection_policy                       = $sfptpd::selection_policy,
  Integer $selection_holdoff_interval            = $sfptpd::selection_holdoff_interval,
  Optional[String] $selection_policy_rules       = $sfptpd::selection_policy_rules,
  String $message_log                            = $sfptpd::message_log,
  Optional[String] $stats_log                    = $sfptpd::stats_log,
  Optional[String] $json_remote_monitor          = $sfptpd::json_remote_monitor,
  Optional[String] $json_stats                   = $sfptpd::json_stats,
  Boolean $daemon                                = $sfptpd::daemon,
  String $lock                                   = $sfptpd::lock,
  Optional[Integer] $sync_interval               = $sfptpd::sync_interval,
  Optional[Integer] $local_sync_threshold        = $sfptpd::local_sync_threshold,
  String $clock_control                          = $sfptpd::clock_control,
  Optional[String] $clock_list                   = $sfptpd::clock_list,
  Optional[String] $persistent_clock_correction  = $sfptpd::persistent_clock_correction,
  Optional[String] $timestamping_interfaces      = $sfptpd::timestamping_interfaces,
  String $timestamping_disable_on_exit           = $sfptpd::timestamping_disable_on_exit,
  String $non_solarflare_nics                    = $sfptpd::non_solarflare_nics,
  String $pid_filter_p                           = $sfptpd::pid_filter_p,
  String $pid_filter_i                           = $sfptpd::pid_filter_i,
  Integer $trace_level                           = $sfptpd::trace_level,
  String $ptp_mgmt_msgs                          = $sfptpd::ptp_mgmt_msgs,
  Integer $ptp_max_foreign_records               = $sfptpd::ptp_max_foreign_records,
  String $ptp_uuid_filtering                     = $sfptpd::ptp_uuid_filtering,
  String $ptp_domain_filtering                   = $sfptpd::ptp_domain_filtering,
  String $package_name                           = $sfptpd::package_name,
  String $package_ensure                         = $sfptpd::package_ensure,
  String $config_file                            = $sfptpd::config_file,
  String $config_file_ensure                     = $sfptpd::config_file_ensure,
  String $config_file_owner                      = $sfptpd::config_file_owner,
  String $config_file_group                      = $sfptpd::config_file_group,
  String $config_file_mode                       = $sfptpd::config_file_mode,
  String $config_file_content_template           = $sfptpd::config_file_content_template,
  Boolean $manage_service                        = $sfptpd::manage_service,
) inherits sfptpd {
  if ($config_file_ensure == 'absent') {
    $config_file_notifies = undef
    $log_dir_ensure = 'absent'
  } else {
    $config_file_notifies = Class[sfptpd::service]
    $log_dir_ensure = 'directory'
  }

  $notifies = $manage_service ? {
    false   => undef,
    default => $config_file_notifies,
  }

  if ('ptp' in $sync_module) {
    $there_is_a_ptp_instance = true
  } else {
    $there_is_a_ptp_instance = false
  }

  concat { $config_file:
    ensure => $config_file_ensure,
    owner  => $config_file_owner,
    group  => $config_file_group,
    mode   => $config_file_mode,
    notify => $notifies,
  }

  concat::fragment { 'sfptpd_base':
    target  => $config_file,
    order   => '0',
    content => template($config_file_content_template),
  }

  if ($manage_logrotate) {
    $possible_files = [$message_log, $json_stats, $stats_log]
    $files = join(delete_undef_values($possible_files), ' ')
    logrotate::rule { 'sfptpd':
      path         => $files,
      compress     => true,
      copytruncate => true,
      missingok    => true,
      rotate_every => 'day',
      rotate       => 7,
    }
  }

  file { '/var/log/sfptpd':
    ensure => $log_dir_ensure,
  }
}
