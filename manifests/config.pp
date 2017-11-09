class sfptpd::config(
  $sync_module                  = $sfptpd::sync_module,
  $selection_policy             = $sfptpd::selection_policy,
  $selection_holdoff_interval   = $sfptpd::selection_holdoff_interval,
  $selection_policy_rules       = $sfptpd::selection_policy_rules,
  $message_log                  = $sfptpd::message_log,
  $stats_log                    = $sfptpd::stats_log,
  $json_remote_monitor          = $sfptpd::json_remote_monitor,
  $json_stats                   = $sfptpd::json_stats,
  $daemon                       = $sfptpd::daemon,
  $lock                         = $sfptpd::lock,
  $sync_interval                = $sfptpd::sync_interval,
  $local_sync_threshold         = $sfptpd::local_sync_threshold,
  $clock_control                = $sfptpd::clock_control,
  $clock_list                   = $sfptpd::clock_list,
  $persistent_clock_correction  = $sfptpd::persistent_clock_correction,
  $timestamping_interfaces      = $sfptpd::timestamping_interfaces,
  $timestamping_disable_on_exit = $sfptpd::timestamping_disable_on_exit,
  $non_solarflare_nics          = $sfptpd::non_solarflare_nics,
  $pid_filter_p                 = $sfptpd::pid_filter_p,
  $pid_filter_i                 = $sfptpd::pid_filter_i,
  $trace_level                  = $sfptpd::trace_level,
  $ptp_mgmt_msgs                = $sfptpd::ptp_mgmt_msgs,
  $ptp_max_foreign_records      = $sfptpd::ptp_max_foreign_records,
  $ptp_uuid_filtering           = $sfptpd::ptp_uuid_filtering,
  $ptp_domain_filtering         = $sfptpd::ptp_domain_filtering,
  $config_file                  = $sfptpd::config_file,
  $config_file_ensure           = $sfptpd::config_file_ensure,
  $config_file_owner            = $sfptpd::config_file_owner,
  $config_file_group            = $sfptpd::config_file_group,
  $config_file_mode             = $sfptpd::config_file_mode,
  $config_file_content_template = $sfptpd::config_file_content_template,
  $manage_service               = $sfptpd::manage_service,
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

  concat::fragment { 'base':
    target  => $config_file,
    order   => '0',
    content => template($config_file_content_template),
  }

  if ($manage_logrotate) {
    $possible_files = [ $message_log, $json_stats, $stats_log ]
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
