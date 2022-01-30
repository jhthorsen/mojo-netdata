# NAME

Mojo::Netdata - https://netdata.cloud plugin for Perl

# SYNOPSIS

## Installation

    sudo -i
    apt install -y cpanminus
    cpanm -n https://github.com/jhthorsen/mojo-netdata/archive/refs/heads/main.tar.gz
    ln -s $(which mojo-netdata) /etc/netdata/custom-plugins.d/mojo-netdata.plugin

    # See "Config file" below for information on what to place inside mojo.conf.pl
    $EDITOR /etc/netdata/mojo.conf.pl

## Config files

The config files are located in `/etc/netdata/mojo.conf.d`. The files are
plain Perl files, which means you can define variables and call functions. The
only important part is that the last statement in the file is a hash-ref.

Any hash-refs that has the "collector" key will be placed into ["collectors"](#collectors),
while everything else will be merged into ["config"](#config). Example:

    # /etc/netdata/mojo.conf.d/foo.conf.pl
    {foo => 42, bar => 100}

    # /etc/netdata/mojo.conf.d/bar.conf.pl
    {collector => 'Mojo::Netdata::Collector::HTTP', jobs => []}

The two config files above will result in this ["config"](#config):

    {
      foo => 42,
      bar => 100,
      collectors => [
        {collector => 'Mojo::Netdata::Collector::HTTP', jobs => []},
      },
    }

See ["SYNOPSIS" in Mojo::Netdata::Collector::HTTP](https://metacpan.org/pod/Mojo%3A%3ANetdata%3A%3ACollector%3A%3AHTTP#SYNOPSIS) for an example config file.

## Log file

The output from this Netdata plugin can be found in
`/var/log/netdata/error.log`.

# DESCRIPTION

[Mojo::Netdata](https://metacpan.org/pod/Mojo%3A%3ANetdata) is a plugin for [Netdata](https://netdata.cloud). It can load
custom [Mojo::Netdata::Collector](https://metacpan.org/pod/Mojo%3A%3ANetdata%3A%3ACollector) classes and write data back to Netdata on a
given interval.

This module is currently EXPERIMENTAL, and the API might change without
warning.

# ATTRIBUTES

## cache\_dir

    $path = $netdata->cache_dir;

Holds the `NETDATA_CACHE_DIR` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## config

    $hash_ref = $netdata->config;

Holds the config for [Mojo::Netdata](https://metacpan.org/pod/Mojo%3A%3ANetdata) and all ["collectors"](#collectors).

## collectors

    $array_ref = $netdata->collectors;

An array-ref of [Mojo::Netdata::Collector](https://metacpan.org/pod/Mojo%3A%3ANetdata%3A%3ACollector) objects.

## debug\_flags

    $str = $netdata->debug_flags;

Defaults to the `NETDATA_DEBUG_FLAGS` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## host\_prefix

    $str = $netdata->host_prefix;

Defaults to the `NETDATA_HOST_PREFIX` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## log\_dir

    $path = $netdata->log_dir;

Holds the `NETDATA_LOG_DIR` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## plugins\_dir

    $path = $netdata->plugins_dir;

Holds the `NETDATA_PLUGINS_DIR` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## stock\_config\_dir

    $path = $netdata->stock_config_dir;

Holds the `NETDATA_STOCK_CONFIG_DIR` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## update\_every

    $num = $netdata->update_every;

Defaults to the `NETDATA_UPDATE_EVERY` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## user\_config\_dir

    $path = $netdata->user_config_dir;

Holds the `NETDATA_USER_CONFIG_DIR` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## web\_dir

    $path = $netdata->web_dir;

Holds the `NETDATA_WEB_DIR` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

# METHODS

## start

    $bool = $netdata->start;

Reads the ["config"](#config) and return 1 if any ["collectors"](#collectors) got registered.

# AUTHOR

Jan Henning Thorsen

# COPYRIGHT AND LICENSE

Copyright (C) Jan Henning Thorsen

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

# SEE ALSO

[https://learn.netdata.cloud/docs/agent/collectors/plugins.d](https://learn.netdata.cloud/docs/agent/collectors/plugins.d).
