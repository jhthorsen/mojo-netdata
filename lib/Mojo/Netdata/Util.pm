package Mojo::Netdata::Util;
use Mojo::Base -strict, -signatures;

use Exporter qw(import);

our @EXPORT_OK = qw(safe_id);

sub safe_id ($str) {
  $str =~ s![^A-Za-z0-9]!_!g;
  $str =~ s!_+$!!g;
  $str =~ s!^_+!!g;
  return $str;
}

1;
