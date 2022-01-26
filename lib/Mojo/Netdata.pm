package Mojo::Netdata;
use Mojo::Base -base, -signatures;

use Mojo::File qw(path);
use Mojo::Netdata::Util qw(logf);

our $VERSION = '0.01';

has collectors       => sub ($self) { $self->_build_collectors };
has config           => sub ($self) { $self->_build_config };
has user_config_dir  => sub ($self) { $ENV{NETDATA_USER_CONFIG_DIR}  || '/etc/netdata' };
has stock_config_dir => sub ($self) { $ENV{NETDATA_STOCK_CONFIG_DIR} || '/usr/lib/netdata/conf.d' };
has plugins_dir      => sub ($self) { $ENV{NETDATA_PLUGINS_DIR}      || '' };
has web_dir          => sub ($self) { $ENV{NETDATA_WEB_DIR}          || '' };
has cache_dir        => sub ($self) { $ENV{NETDATA_CACHE_DIR}        || '' };
has log_dir          => sub ($self) { $ENV{NETDATA_LOG_DIR}          || '' };
has host_prefix      => sub ($self) { $ENV{NETDATA_HOST_PREFIX}      || '' };
has debug_flags      => sub ($self) { $ENV{NETDATA_DEBUG_FLAGS}      || '' };
has update_every     => sub ($self) { $ENV{NETDATA_UPDATE_EVERY}     || 1 };

sub start ($self) {
  logf(info => 'Starting %s', __PACKAGE__);
  return 0 unless @{$self->collectors};
  $_->emit_charts->recurring_update_p for @{$self->collectors};
  return int @{$self->collectors};
}

sub _build_config ($self) {
  my $file = path($self->user_config_dir, 'mojo.conf.pl')->to_abs;
  unless (-r $file) {
    logf(warnings => 'Config file "%s" could not be read.', $file);
    return {};
  }

  local $@;
  my $config
    = eval 'package Mojo::Netdata::Config; no warnings; use Mojo::Base -strict;' . $file->slurp;
  return $config if $config;

  logf(error => 'Config file "%s" is invalid: %s', $file, $@);
  return {};
}

sub _build_collectors ($self) {
  my $fh = $self->{stdout} // \*STDOUT;    # for testing
  my @collectors;

  local $@;
  for my $collector_config (@{$self->config->{collectors} || []}) {
    my $collector_class = $collector_config->{class};

    unless ($collector_class and $collector_class =~ m!^[\w:]+$!) {
      logf(error => 'Invalid collector_class %s', $collector_class || 'missing');
      next;
    }
    unless (eval "require $collector_class;1") {
      logf(error => 'Load %s FAIL %s', $collector_class, $@);
      next;
    }

    my %attrs = (update_every => $collector_config->{update_every} || $self->update_every);
    next unless my $collector = $collector_class->new(%attrs)->register($collector_config, $self);
    $collector->on(stdout => sub ($collector, $str) { print {$fh} $str });
    logf(info => 'Loaded and set up %s', $collector_class);
    push @collectors, $collector;
  }

  return \@collectors;
}

1;

=encoding utf8

=head1 NAME

Mojo::Netdata - https://netdata.cloud plugin for Perl

=head1 SYNOPSIS

=head2 CONFIG FILE

TODO

=head2 INSTALLATION

TODO

=head1 DESCRIPTION

L<Mojo::Netdata> is a plugin for
L<Netdata|https://learn.netdata.cloud/docs/agent/collectors/plugins.d>. It can
load custom L<Mojo::Netdata::Collector> classes and write data back to Netdata
on a given interval.

This module is currently EXPERIMENTAL, and the API might change without
warning.

=head1 ATTRIBUTES

=head2 cache_dir

  $path = $netdata->cache_dir;

Holds the C<NETDATA_CACHE_DIR> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head2 config

  $hash_ref = $netdata->config;

Holds the config for L<Mojo::Netdata> and all L</collectors>.

=head2 collectors

  $array_ref = $netdata->collectors;

An array-ref of L<Mojo::Netdata::Collector> objects.

=head2 debug_flags

  $str = $netdata->debug_flags;

Defaults to the C<NETDATA_DEBUG_FLAGS> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head2 host_prefix

  $str = $netdata->host_prefix;

Defaults to the C<NETDATA_HOST_PREFIX> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head2 log_dir

  $path = $netdata->log_dir;

Holds the C<NETDATA_LOG_DIR> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head2 plugins_dir

  $path = $netdata->plugins_dir;

Holds the C<NETDATA_PLUGINS_DIR> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head2 stock_config_dir

  $path = $netdata->stock_config_dir;

Holds the C<NETDATA_STOCK_CONFIG_DIR> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head2 update_every

  $seconds = $netdata->update_every;

Defaults to the C<NETDATA_UPDATE_EVERY> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head2 user_config_dir

  $path = $netdata->user_config_dir;

Holds the C<NETDATA_USER_CONFIG_DIR> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head2 web_dir

  $path = $netdata->web_dir;

Holds the C<NETDATA_WEB_DIR> environment variable. See
L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables>
for more details.

=head1 METHODS

=head2 start

  $bool = $netdata->start;

Reads the L</config> and return 1 if any L</collectors> got registered.

=head1 AUTHOR

Jan Henning Thorsen

=head1 COPYRIGHT AND LICENSE

Copyright (C) Jan Henning Thorsen

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

=head1 SEE ALSO

L<https://learn.netdata.cloud/docs/agent/collectors/plugins.d>.

=cut
