#
class sfptpd::service (
  Boolean $manage_service     = $sfptpd::manage_service,
  String $service_name        = $sfptpd::service_name,
  String $service_ensure      = $sfptpd::service_ensure,
  Boolean $service_enable     = $sfptpd::service_enable,
  Boolean $service_hasrestart = $sfptpd::service_hasrestart,
  Boolean $service_hasstatus  = $sfptpd::service_hasstatus,
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
