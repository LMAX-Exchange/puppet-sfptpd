class sfptpd::service(
  $manage_service             = $sfptpd::manage_service,
  $service_name               = $sfptpd::service_name,
  $service_ensure             = $sfptpd::service_ensure,
  $service_enable             = $sfptpd::service_enable,
  $service_hasrestart         = $sfptpd::service_hasrestart,
  $service_hasstatus          = $sfptpd::service_hasstatus,
) inherits sfptpd {
  if ($manage_service) {
    service { $service_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => $service_hasstatus,
      hasrestart => $service_hasrestart,
    }
  }
}
