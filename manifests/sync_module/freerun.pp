# sfptpd::sync_module::freerun
define sfptpd::sync_module::freerun (
  String $interface,
  Optional[Integer] $priority  = undef,
) {
  concat::fragment { "freerun_${name}":
    target  => $::sfptpd::config_file,
    content => template("${module_name}/freerun.erb"),
    order   => 70,
  }
}
