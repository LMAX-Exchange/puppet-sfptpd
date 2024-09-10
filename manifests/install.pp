#
class sfptpd::install (
  String $package_name   = $sfptpd::package_name,
  String $package_ensure = $sfptpd::package_ensure,
) inherits sfptpd {
  package { $package_name:
    ensure  => $package_ensure,
  }
}
