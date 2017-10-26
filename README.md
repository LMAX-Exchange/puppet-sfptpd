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
* Supports multiple sfptpd 'sync module' configurations
* Manages the sfptpd service

### Setup Requirements

The sfptpd package can be found on SolarFlare's webiste: https://support.solarflare.com/

### Beginning with sfptpd

sfptpd runs in many different ways. It can do PTP, PPS, NTP and free running.

sfptpd needs to be customised to your environment and use case. A good starting point is
SolarFlare's Enhanced PTP Quick Start Guide:

http://solarflare.com/Content/UserFiles/Documents/Solarflare_Enhanced_PTP_Quick_Start_Guide.pdf

After that, the comprehensive Enhanced PTP User Guide. Once you have a thorough understanding
of what you want to achieve, the sfptpd Puppet module can be used to configure your use cases.

## Usage

An example of sfptpd with a single PTP sync module:

~~~ puppet
class { 'sfptpd':
  sync_module => { 'ptp' => [ 'ptp1' ] },
}
sfptpd::sync_module::ptp { 'ptp1':
  interface => 'eth0',
}
~~~

An example of sfptpd using PPS and NTP:

~~~ puppet
class { 'sfptpd': 
  sync_module => { 'pps' => [ 'pps1' ], 'ntp' => [ 'ntp1' ], },
  selection_policy => 'manual pps1',
}
sfptpd::sync_module::pps { 'pps1':
  interface => 'eth0',
  priority  => 10,
}
sfptpd::sync_module::ntp { 'ntp1':
  priority => 20,
  ntp_key  => '15 woof',
}
~~~

### Daemon or Foreground

You may have a use case to run sfptpd in the foreground, say with supervisord. You will also
need to stop managing the service to prevent Puppet from trying to start/stop anything:

~~~ puppet
class { 'sfptpd':
  daemon         => false,
  manage_service => false,
}
~~~

### Logging and Log Rotation

The sfptpd module logs to a file by default, and it uses a 'logrotate::rule' defined type
(from https://github.com/voxpupuli/puppet-logrotate). To disable the use of this type, or 
change to logging via Syslog, you can do this:

~~~ puppet
class { 'sfptpd':
  manage_logrotate => false,
  message_log      => 'syslog',
}
~~~

### Statistics

You can also turn on PTP statistics logging and/or machine parseable JSON stats like so:

~~~ puppet
class { 'sfptpd':
  stats_log  => '/var/log/sfptpd/sfptpd.stats',
  json_stats => '/var/log/sfptpd/sfptpd.json',
}
~~~

## Limitations

This version of the sfptpd module assumes sfptpd-3.2.1 or later.

At the moment, the module is only tested against CentOS 6, however the code is simple
enough that it's not expected to have any problems with other distributions. There are certain
things you won't want to turn off non-Red Hat systems though, like managing the init script.

## Development

We will accept pull requests on Git Hub.

### Running Tests

Tests utilise both rspec-puppet and beaker-rspec.
