# sfptpd

[![Build Status](https://travis-ci.org/LMAX-Exchange/puppet-sfptpd.svg?branch=master)](https://travis-ci.org/LMAX-Exchange/puppet-sfptpd)

#### Table of Contents

1. [Module Description](#module-description)
2. [Setup](#setup)
    * [What sfptpd affects](#what-sfptpd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sfptpd](#beginning-with-sfptpd)
3. [Usage](#usage)
4. [Limitations](#limitations)
5. [Development](#development)
    * [Running Tests](#Running Tests)

## Module Description

This module manages SolarFlare's Enhanced Precision Time Synchronisation (PTP) Daemon, sfptpd,
which is a derivitive of the open source PTP daemon (http://ptpd.sourceforge.net), and is
designed to run in conjunction with SolarFlare's PTP adapters.

## Setup

### What the sfptpd Puppet module affects

* Installs the sfptpd package
* Supports the different ways sfptpd can be configured; ptp mode and freerun mode
* Manages the sfptpd service

### Setup Requirements

The sfptpd package can be found on SolarFlare's webiste: https://support.solarflare.com/

### Beginning with sfptpd

sfptpd runs in one of many modes. It can be a PTP Master time source, a PTP Slave, or in a
freerun mode where it synchronises SolarFlare adapter clocks to the server system clock or NTP.

sfptpd needs to be customised to your environment and use case. A good starting point is
SolarFlare's Enhanced PTP Quick Start Guide:

http://solarflare.com/Content/UserFiles/Documents/Solarflare_Enhanced_PTP_Quick_Start_Guide.pdf

After that, the comprehensive Enhanced PTP User Guide. Once you have a thorough understanding
of what you want to achieve, the sfptpd Puppet module can be used to configure your use cases.

## Usage

An example of sfptpd in PTP Slave mode:

~~~ puppet
class { 'sfptpd': 
  sync_mode => 'ptp',
  interface => 'eth1',
  ptp_mode  => 'slave',
}
~~~

An example of sfptpd in freerun NTP mode:

~~~ puppet
class { 'sfptpd': 
  sync_mode    => 'freerun',
  freerun_mode => 'ntp',
  ntp_mode     => 'read-only',
}
~~~

### Daemon or Foreground

On Red Hat / CentOS and with sfptpd version 2.2.4.70-1 there is a minor bug in the init script
where it does not return the correct number for the 'status' action, so Puppet would never
restart the service. To fix this the sfptpd module manages the Red Hat init script. This can be disabled
like so:

~~~ puppet
class { 'sfptpd':
  manage_init_script => false,
}
~~~

You may have a use case to run sfptpd in the foreground, say with supervisord. You cannot set
$service_ensure=stopped because the init script will attempt to shut down any running sfptpd process.
Due to the way class parameters work in Puppet 3, neither can you set $service_ensure=undef,
as the Puppet Parser will still take the default parameter value. There is a separate boolean to
force the module to not manage the ensure parameter of the sfptpd service:

~~~ puppet
class { 'sfptpd':
  daemon                     => false,
  service_ensure_force_undef => true,
  service_enable             => false,
}
~~~

### Logging and Log Rotation

The sfptpd module logs to a file by default, and it uses a 'logrotate::rule' defined type
(from https://github.com/b4ldr/puppet-logrotate). To disable the use of this type, or 
change to logging via Syslog, you can do this:

~~~ puppet
class { 'sfptpd':
  manage_logrotate => false,
  message_log      => 'syslog',
}
~~~

You can also turn on PTP statistics logging which will write to /var/log/sfptpd/stats.log, or,
specify your own stats log file like so:

~~~ puppet
class { 'sfptpd':
  stats_log_enable => true,
  stats_log_file   => '/tmp/sfptpd_stats.log',
}
~~~

## Limitations

At the moment, the module is only tested against CentOS 6, however the code is simple
enough that it's not expected to have any problems with other distributions. There are certain
things you won't want to turn off non-Red Hat systems though, like managing the init script.

## Development

We will accept pull requests on Git Hub.

### Running Tests

Tests utilise both rspec-puppet and beaker-rspec.
