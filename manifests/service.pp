class sfptpd::service(
  $service_name               = $sfptpd::service_name,
  $service_ensure             = $sfptpd::service_ensure,
  $service_ensure_force_undef = $sfptpd::service_ensure_force_undef,
  $service_enable             = $sfptpd::service_enable,
  $service_hasrestart         = $sfptpd::service_hasrestart,
  $service_hasstatus          = $sfptpd::service_hasstatus,
) inherits sfptpd {
  assert_private()
  service { $service_name:
    ensure     => $service_ensure_force_undef ? {
      true    => undef,
      default => $service_ensure,
    },
    enable     => $service_enable,
    hasstatus  => $service_hasstatus,
    hasrestart => $service_hasrestart,
  }
}
