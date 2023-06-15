#LB: defaults from the 2.2.4.70-1 version of SolarFlare's RPM
class sfptpd::params {
  $selection_policy             = 'automatic'
  $selection_holdoff_interval   = 10
  $selection_policy_rules       = undef
  $message_log                  = '/var/log/sfptpd/sfptpd.log'
  $stats_log                    = undef
  $json_remote_monitor          = undef
  $json_stats                   = undef
  # Daemon mode conflicts with systemd, so don't enable the daemon option on EL8 and above.
  if Integer($facts['os']['release']['major']) >= 8 {
    $daemon = false
  }
  else {
    $daemon = true
  }
  $lock                         = 'on'
  $sync_interval                = undef
  $local_sync_threshold         = undef
  $clock_control                = 'slew-and-step'
  $clock_list                   = undef
  $clock_readonly               = undef
  $epoch_guard                  = 'prevent-sync'
  $persistent_clock_correction  = 'on'
  $timestamping_interfaces      = undef
  $timestamping_disable_on_exit = 'on'
  $non_solarflare_nics          = 'off'
  $pid_filter_p                 = '0.4'
  $pid_filter_i                 = '0.03'
  $trace_level                  = 0
  $ptp_mgmt_msgs                = 'disabled'
  $ptp_max_foreign_records      = 16
  $ptp_uuid_filtering           = 'on'
  $ptp_domain_filtering         = 'on'
  $package_name                 = 'sfptpd'
  $package_ensure               = 'installed'
  $config_file                  = '/etc/sfptpd.conf'
  $config_file_ensure           = 'present'
  $config_file_owner            = '0'
  $config_file_group            = '0'
  $config_file_mode             = '0755'
  $config_file_content_template = 'sfptpd/sfptpd.conf.erb'
  $manage_service               = true
  $service_name                 = 'sfptpd'
  $service_ensure               = 'running'
  $service_enable               = true
  $service_hasrestart           = true
  $service_hasstatus            = true
  $manage_logrotate             = true
  $time_of_day                  = undef
  $outlier_filter_type          = 'std-dev'
  $outlier_filter_size          = 30
  $outlier_filter_adaption      = 1.0
  $fir_filter_size              = 4
}
