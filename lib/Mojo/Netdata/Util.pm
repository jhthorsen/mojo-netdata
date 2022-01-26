package Mojo::Netdata::Util;
use Mojo::Base -strict, -signatures;

use Exporter qw(import);

our @EXPORT_OK = qw(safe_id);

sub safe_id ($str) {
  $str =~ s![^A-Za-z0-9]!_!g;
  $str =~ s!_+$!!g;
  $str =~ s!^_+!!g;
  return lc $str;
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

=head2 safe_id

  $str = safe_id $str;

=head1 SEE ALSO

L<Mojo::Netdata>.

=cut
