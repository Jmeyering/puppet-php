# Class: php::params
#
# This class defines default parameters used by the main module class php
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to php class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class php::params {

  $package_devel = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => 'php5-dev',
    /(?i:SLES|OpenSuSe)/      => 'php5-devel',
    default                   => 'php-devel',
  }

  ### Application related parameters
  $module_prefix = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => 'php5-',
    default                                 => 'php-',
  }

  $package = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint)/ => 'php5',
    /(?i:SLES|OpenSuSE)/      => [ 'php5','apache2-mod_php5'],
    default                   => 'php',
  }

  # Here it's not the php service script name but
  # web service name like apache2, nginx, etc.
  $service = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => 'apache2',
    default                                 => 'httpd',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => '/etc/php5',
    default                                   => '/etc/php.d',
  }

  $config_file = $::operatingsystem ? {
    /(?i:Ubuntu|Debian|Mint|SLES|OpenSuSE)/ => '/etc/php5/apache2/php.ini',
    default                                 => '/etc/php.ini',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  # General Settings
  $source = ''
  $source_dir = ''
  $source_dir_purge = false
  $template = ''
  $options = ''
  $version = 'present'
  $service_autorestart = true
  $absent = false
  $install_options = []

  ### General module variables that can have a site or per module default
  $debug = false
  $audit_only = false

}
