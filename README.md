# NAME

Mojo::Netdata - https://netdata.cloud plugin for Perl

# SYNOPSIS

## CONFIG FILE

TODO

## INSTALLATION

TODO

# DESCRIPTION

[Mojo::Netdata](https://metacpan.org/pod/Mojo%3A%3ANetdata) is a plugin for
[Netdata](https://learn.netdata.cloud/docs/agent/collectors/plugins.d). It can
load custom [Mojo::Netdata::Collector](https://metacpan.org/pod/Mojo%3A%3ANetdata%3A%3ACollector) classes and write data back to Netdata
on a given interval.

# ATTRIBUTES

## cache\_dir

    $path = $netdata->cache_dir;

Holds a [Mojo::File](https://metacpan.org/pod/Mojo%3A%3AFile) pointing to the `NETDATA_CACHE_DIR` environment
variable. See [https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

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

Holds a [Mojo::File](https://metacpan.org/pod/Mojo%3A%3AFile) pointing to the `NETDATA_LOG_DIR` environment
variable. See [https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## plugins\_dir

    $path = $netdata->plugins_dir;

Holds a [Mojo::File](https://metacpan.org/pod/Mojo%3A%3AFile) pointing to the `NETDATA_PLUGINS_DIR` environment
variable. See [https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## stdout

    $fh = $netdata->stdout;

Holds a filehandle that will be written to. Default to STDOUT, but can be
changed for easier testing.

## stock\_config\_dir

    $path = $netdata->stock_config_dir;

Holds a [Mojo::File](https://metacpan.org/pod/Mojo%3A%3AFile) pointing to the `NETDATA_STOCK_CONFIG_DIR` environment
variable. See [https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## update\_every

    $seconds = $netdata->update_every;

Defaults to the `NETDATA_UPDATE_EVERY` environment variable. See
[https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## user\_config\_dir

    $path = $netdata->user_config_dir;

Holds a [Mojo::File](https://metacpan.org/pod/Mojo%3A%3AFile) pointing to the `NETDATA_USER_CONFIG_DIR` environment
variable. See [https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

## web\_dir

    $path = $netdata->web_dir;

Holds a [Mojo::File](https://metacpan.org/pod/Mojo%3A%3AFile) pointing to the `NETDATA_WEB_DIR` environment
variable. See [https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables](https://learn.netdata.cloud/docs/agent/collectors/plugins.d#environment-variables)
for more details.

# METHODS

## read\_config

    $netdata = $netdata->read_config;

Reads the config file and sets up ["collectors"](#collectors).

## run

    $netdata->run;

Reads the [config](#read_config) and starts [Mojo::IOLoop](https://metacpan.org/pod/Mojo%3A%3AIOLoop) if any
["collectors"](#collectors) got registered. Prints "DISABLE" to ["stdout"](#stdout) and returns right
away if no collectors was set up.

# AUTHOR

Jan Henning Thorsen

# COPYRIGHT AND LICENSE

Copyright (C) Jan Henning Thorsen

This program is free software, you can redistribute it and/or modify it under
the terms of the Artistic License version 2.0.

# SEE ALSO

[https://learn.netdata.cloud/docs/agent/collectors/plugins.d](https://learn.netdata.cloud/docs/agent/collectors/plugins.d).
