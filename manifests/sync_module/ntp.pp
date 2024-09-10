# sfptpd::sync_module::ntp
define sfptpd::sync_module::ntp (
  Pattern[/^\d+\s+\S+/] $ntp_key,
  Optional[Integer] $priority       = undef,
  Optional[Integer] $sync_threshold = undef,
  Integer $ntp_poll_interval        = 1,
) {
  concat::fragment { "ntp_${name}":
    target  => $sfptpd::config_file,
    content => template("${module_name}/ntp.erb"),
    order   => 50,
  }
}
