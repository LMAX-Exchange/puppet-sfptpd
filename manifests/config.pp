class sfptpd::config(
  $sync_mode                    = $sfptpd::sync_mode,
  $interface                    = $sfptpd::interface,
  $message_log                  = $sfptpd::message_log,
  $stats_log_file               = $sfptpd::stats_log_file,
  $daemon                       = $sfptpd::daemon,
  $lock                         = $sfptpd::lock,
  $clock_control                = $sfptpd::clock_control,
  $persistent_clock_correction  = $sfptpd::persistent_clock_correction,
  $timestamping_interfaces      = $sfptpd::timestamping_interfaces,
  $timestamping_disable_on_exit = $sfptpd::timestamping_disable_on_exit,
  $trace_level                  = $sfptpd::trace_level,
  $ptp_mode                     = $sfptpd::ptp_mode,
  $ptp_stats                    = $sfptpd::ptp_stats,
  $ptp_pkt_dump                 = $sfptpd::ptp_pkt_dump,
  $ptp_pps_log                  = $sfptpd::ptp_pps_log,
  $pps_delay                    = $sfptpd::pps_delay,
  $ptp_delay_discard_threshold  = $sfptpd::ptp_delay_discard_threshold,
  $ptp_tx_latency               = $sfptpd::ptp_tx_latency,
  $ptp_rx_latency               = $sfptpd::ptp_rx_latency,
  $ptp_network_mode             = $sfptpd::ptp_network_mode,
  $ptp_ttl                      = $sfptpd::ptp_ttl,
  $ptp_utc_valid_handling       = $sfptpd::ptp_utc_valid_handling,
  $ptp_domain                   = $sfptpd::ptp_domain,
  $ptp_mgmt_msgs                = $sfptpd::ptp_mgmt_msgs,
  $ptp_timing_acl_permit        = $sfptpd::ptp_timing_acl_permit,
  $ptp_timing_acl_deny          = $sfptpd::ptp_timing_acl_deny,
  $ptp_timing_acl_order         = $sfptpd::ptp_timing_acl_order,
  $ptp_mgmt_acl_permit          = $sfptpd::ptp_mgmt_acl_permit,
  $ptp_mgmt_acl_deny            = $sfptpd::ptp_mgmt_acl_deny,
  $ptp_mgmt_acl_order           = $sfptpd::ptp_mgmt_acl_order,
  $ptp_announce_timeout         = $sfptpd::ptp_announce_timeout,
  $ptp_sync_pkt_timeout         = $sfptpd::ptp_sync_pkt_timeout,
  $ptp_sync_pkt_interval        = $sfptpd::ptp_sync_pkt_interval,
  $ptp_delayreq_interval        = $sfptpd::ptp_delayreq_interval,
  $ptp_delayresp_timeout        = $sfptpd::ptp_delayresp_timeout,
  $ptp_max_foreign_records      = $sfptpd::ptp_max_foreign_records,
  $ptp_uuid_filtering           = $sfptpd::ptp_uuid_filtering,
  $ptp_domain_filtering         = $sfptpd::ptp_domain_filtering,
  $ptp_trace                    = $sfptpd::ptp_trace,
  $freerun_mode                 = $sfptpd::freerun_mode,
  $ntp_mode                     = $sfptpd::ntp_mode,
  $ntp_poll_interval            = $sfptpd::ntp_poll_interval,
  $ntp_key                      = $sfptpd::ntp_key,
  $config_file                  = $sfptpd::config_file,
  $config_file_ensure           = $sfptpd::config_file_ensure,
  $config_file_owner            = $sfptpd::config_file_owner,
  $config_file_group            = $sfptpd::config_file_group,
  $config_file_mode             = $sfptpd::config_file_mode,
  $config_file_content_template = $sfptpd::config_file_content_template,
  $manage_service               = $sfptpd::manage_service,
) inherits sfptpd {
  assert_private()

  if ($config_file_ensure == 'absent') {
    $config_file_notifies = undef
    $log_dir_ensure = 'absent'
  } else {
    $config_file_notifies = Class[sfptpd::service]
    $log_dir_ensure = 'directory'
  }

  file { $config_file:
    ensure  => $config_file_ensure,
    owner   => $config_file_owner,
    group   => $config_file_group,
    mode    => $config_file_mode,
    content => template($config_file_content_template),
    notify  => $manage_service ? {
      false   => undef,
      default => $config_file_notifies,
    },
  }

  if ($manage_init_script) {
    file { $sfptpd_init_script:
      ensure  => $config_file_ensure,
      owner   => 0,
      group   => 0,
      mode    => '0755',
      content => template("${module_name}/sfptpd.init.erb"),
      notify  => $manage_service ? {
        false   => undef,
        default => $config_file_notifies,
      },
    }
  }

  if ($manage_logrotate) {
    logrotate::rule { 'sfptpd':
      path         => '/var/log/sfptpd/*.log',
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
