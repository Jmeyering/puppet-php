# = Class: php
#
# This is the main php class
#
#
# == Parameters
#
# Module specific parameters
# [*package_devel*]
#   Name of the php-devel package
#
# [*package_pear*]
#   Name of the php-pear package
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*service*]
#   The service that runs the php interpreter. Defines what service gets
#   notified. Default: apache2|httpd.
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, php main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $php_source
#
# [*source_dir*]
#   If defined, the whole php configuration directory content is retrieved
#   recursively from the specified source
#   (source => $source_dir , recurse => true)
#   Can be defined also by the (top scope) variable $php_source_dir
#
# [*source_dir_purge*]
#   If set to true (default false) the existing configuration directory is
#   mirrored with the content retrieved from source_dir
#   (source => $source_dir , recurse => true , purge => true, force => true)
#   Can be defined also by the (top scope) variable $php_source_dir_purge
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, php main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $php_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $php_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*install_options*]
#   The package install options to be passed to the package manager. Useful for
#   setting advanced/custom options during package install/update.
#   For example, adding a `--enablerepo` option to Yum or specifying a
#   `--no-install-recommends` option during an Apt install.
#   NOTE: The `install_options` package class parameter was added for Yum/Apt
#   in Puppet 3.6. Its format of the option is an array, where each option in
#   the array is either a string or a hash.
#   Example: `install_options => ['-y', {'--enablerepo' => 'remi-php55'}]`
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $php_absent
#
# [*debug*]
#   Set to 'true' to enable modules debugging
#   Can be defined also by the (top scope) variables $php_debug and $debug
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $php_audit_only
#   and $audit_only
#
# Default class params - As defined in php::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of php package
#
# [*config_file*]
#   Main configuration file path
#
# [*config_file_mode*]
#   Main configuration file path mode
#
# [*config_file_owner*]
#   Main configuration file path owner
#
# [*config_file_group*]
#   Main configuration file path group
#
# [*config_file_init*]
#   Path of configuration file sourced by init script
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include php"
# - Call php as a parametrized class
#
# See README for details.
#
#
class php (
  $package_devel       = $php::params::package_devel,
  $service             = $php::params::service,
  $service_autorestart = $php::params::service_autorestart,
  $source              = $php::params::source,
  $source_dir          = $php::params::source_dir,
  $source_dir_purge    = $php::params::source_dir_purge,
  $template            = $php::params::template,
  $options             = $php::params::options,
  $version             = $php::params::version,
  $install_options     = $php::params::install_options,
  $absent              = $php::params::absent,
  $debug               = $php::params::debug,
  $audit_only          = $php::params::audit_only,
  $package             = $php::params::package,
  $module_prefix       = $php::params::module_prefix,
  $config_dir          = $php::params::config_dir,
  $config_file         = $php::params::config_file,
  $config_file_mode    = $php::params::config_file_mode,
  $config_file_owner   = $php::params::config_file_owner,
  $config_file_group   = $php::params::config_file_group,
  ) {


  ### Definition of some variables used in the module
  $manage_package = $absent ? {
    true  => 'absent',
    false => $version,
  }

  $manage_file = $absent ? {
    true    => 'absent',
    default => 'present',
  }


  $manage_audit = $audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $audit_only ? {
    true  => false,
    false => true,
  }

  if ($source != '' and $template != '') {
    fail ('PHP: cannot set both source and template')
  }

  $manage_file_source = $source ? {
    ''        => undef,
    default   => $source,
  }

  $manage_file_content = $template ? {
    ''        => undef,
    default   => template($template),
  }

  $realservice_autorestart = $service_autorestart ? {
    true  => Service[$service],
    false => undef,
  }

  ### Managed resources
  package { 'php':
    ensure          => $manage_package,
    name            => $package,
    install_options => $install_options,
  }

  file { 'php.conf':
    ensure  => $manage_file,
    path    => $config_file,
    mode    => $config_file_mode,
    owner   => $config_file_owner,
    group   => $config_file_group,
    require => Package['php'],
    source  => $manage_file_source,
    content => $manage_file_content,
    replace => $manage_file_replace,
    audit   => $manage_audit,
    notify  => $realservice_autorestart,
  }

  # The whole php configuration directory can be recursively overriden
  if $source_dir != ''{
    file { 'php.dir':
      ensure  => directory,
      path    => $config_dir,
      require => Package['php'],
      source  => $source_dir,
      recurse => true,
      links   => follow,
      purge   => $source_dir_purge,
      force   => $source_dir_purge,
      replace => $manage_file_replace,
      audit   => $manage_audit,
    }
  }


  ### Debugging, if enabled ( debug => true )
  if $debug == true {
    file { 'debug_php':
      ensure  => $manage_file,
      path    => "${settings::vardir}/debug-php",
      mode    => '0640',
      owner   => 'root',
      group   => 'root',
      content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.to_yaml %>'),
    }
  }

}
