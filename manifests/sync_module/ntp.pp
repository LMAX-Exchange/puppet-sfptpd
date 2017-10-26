define sfptpd::sync_module::ntp(
  $ntp_key,
  $priority          = undef,
  $sync_threshold    = undef,
  $ntp_poll_interval = 1,
) {
  validate_re($ntp_key, '^\d+\s+\S+')
  validate_integer($ntp_poll_interval)

  concat::fragment { "ntp_${name}":
    target  => $::sfptpd::config_file,
    content => template("${module_name}/ntp.erb"),
    order   => 50,
  }
}
