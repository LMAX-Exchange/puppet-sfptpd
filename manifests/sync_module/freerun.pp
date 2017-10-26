define sfptpd::sync_module::freerun(
  $interface,
  $priority  = undef,
) {
  validate_string($interface)

  concat::fragment { "freerun_${name}":
    target  => $::sfptpd::config_file,
    content => template("${module_name}/freerun.erb"),
    order   => 60,
  }
}
