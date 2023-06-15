# sfptpd::sync_module::crny
define sfptpd::sync_module::crny (
  Optional[Integer] $priority       = undef,
  Optional[Integer] $sync_threshold = undef,
  Integer $ntp_poll_interval = 1,
  Optional[String] $control_script = undef,
) {
  concat::fragment { "crny_${name}":
    target  => $sfptpd::config_file,
    content => template("${module_name}/crny.erb"),
    order   => 60,
  }
}
