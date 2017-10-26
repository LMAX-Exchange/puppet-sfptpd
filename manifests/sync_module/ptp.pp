define sfptpd::sync_module::ptp(
  $interface,
  $ptp_mode                  = 'slave',
  $priority                  = undef,
  $sync_threshold            = undef,
  $ptp_pkt_dump              = false,
  $ptp_pps_log               = false,
  $ptp_tx_latency            = undef,
  $ptp_rx_latency            = undef,
  $ptp_delay_mechanism       = 'end-to-end',
  $ptp_network_mode          = 'hybrid',
  $ptp_ttl                   = 64,
  $ptp_utc_valid_handling    = undef,
  $ptp_domain                = 0,
  $ptp_timing_acl_allow      = undef,
  $ptp_timing_acl_deny       = undef,
  $ptp_timing_acl_order      = undef,
  $ptp_mgmt_acl_allow        = undef,
  $ptp_mgmt_acl_deny         = undef,
  $ptp_mgmt_acl_order        = undef,
  $ptp_announce_interval     = 1,
  $ptp_announce_timeout      = 6,
  $ptp_delayreq_interval     = undef,
  $ptp_delayresp_timeout     = -2,
  $ptp_bmc_priority1         = undef,
  $ptp_bmc_priority2         = undef,
  $ptp_trace                 = 0,
  $pid_filter_p              = '0.2',
  $pid_filter_i              = '0.003',
  $remote_monitor            = undef,
  $json_remote_monitor       = undef,
  $mon_monitor_address       = undef,
  $mon_rx_sync_timing_data   = undef,
  $mon_rx_sync_computed_data = undef,
  $outlier_filter_size       = 60,
  $outlier_filter_adaption   = 1,
  $mpd_filter_size           = 8,
  $mpd_filter_ageing         = undef,
  $fir_filter_size           = 1,
) {
  validate_string($interface)
  validate_re($ptp_mode, [ '^slave$', '^master$'],
    "Parameter 'ptp_mode' must be either 'slave' or 'master'")
  validate_bool($ptp_pkt_dump)
  validate_bool($ptp_pps_log)
  validate_re($ptp_delay_mechanism, [ '^end-to-end$', '^peer‐to‐peer$' ],
    "Parameter 'ptp_delay_mechanism' must be either 'end-to-end' or 'peer‐to‐peer'")
  validate_re($ptp_network_mode, [ '^hybrid$', '^multicast$' ],
    "Parameter 'ptp_network_mode' must be either 'hybrid' or 'multicast'")
  validate_integer($ptp_ttl)
  validate_integer($ptp_domain)
  validate_integer($ptp_announce_interval)
  validate_integer($ptp_announce_timeout)
  validate_integer($ptp_trace)
  validate_integer($outlier_filter_size)
  validate_integer($outlier_filter_adaption)
  validate_integer($mpd_filter_size)
  validate_integer($fir_filter_size)

  concat::fragment { "ptp_${name}":
    target  => $::sfptpd::config_file,
    content => template("${module_name}/ptp.erb"),
    order   => 40,
  }
}
