class sfptpd::install(
  $package_name   = $sfptpd::package_name,
  $package_ensure = $sfptpd::package_ensure,
) inherits sfptpd {
  package { $package_name:
    ensure  => $package_ensure,
  }
}
