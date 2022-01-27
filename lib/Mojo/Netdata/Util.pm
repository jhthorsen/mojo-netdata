package Mojo::Netdata::Util;
use Mojo::Base -strict, -signatures;

use Exporter qw(import);
use Mojo::File;

our @EXPORT_OK = qw(logf safe_id);

sub logf ($level, $format, @args) {
  return 1 if $ENV{HARNESS_ACTIVE} and !$ENV{HARNESS_IS_VERBOSE};

  my $module_name = caller;
  my ($s, $m, $h, $day, $month, $year) = localtime time;

  state $program_name = Mojo::File->new($0)->basename;
  printf STDERR "%s-%02s-%02s %02s:%02s:%02s: %s: %s: %s: $format\n", $year + 1900, $month + 1,
    $day, $h, $m, $s, $program_name, uc $level, $module_name, @args;
  return 1;
}

sub safe_id ($str) {
  $str =~ s![^A-Za-z0-9]!_!g;
  $str =~ s!_+$!!g;
  $str =~ s!^_+!!g;
  return $str;
}

1;

=encoding utf8

=head1 NAME

Mojo::Netdata::Util - Utility functions for Mojo::Netdata

=head1 SYNOPSIS

  use Mojo::Netdata::Util qw(safe_id);
  print safe_id 'Not%co.ol';

=head1 DESCRIPTION

L<Mojo::Netdata::Util> as functions that can be useful when working with
L<Mojo::Netdata::Collector> classes.

=head1 EXPORTED FUNCTIONS

=head2 logf

  logf $level, $format, @args;

Used to log messages to STDERR. C<$level> can be "debug", "info", "warnings",
"error", "fatal".

=head2 safe_id

  $str = safe_id $str;

Turns an "unsafe" string into a string you can use for things like "id" or
"type". This is called by L<Mojo::Netdata::Chart/to_string> and
L<Mojo::Netdata::Chart/data_to_string> to make sure the output strings are
safe.

=head1 SEE ALSO

L<Mojo::Netdata>.

=cut
