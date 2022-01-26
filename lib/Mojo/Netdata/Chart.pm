package Mojo::Netdata::Chart;
use Mojo::Base -base, -signatures;

use Carp qw(croak);

has chart_type   => 'line';                                            # {area,line,stacked}
has context      => 'default';
has dimensions   => sub ($self) { +{} };
has family       => sub ($self) { $self->id };
has id           => sub ($self) { croak '"id" cannot be built' };
has module       => '';
has name         => '';
has options      => '';                                                # "detail hidden obsolete"
has plugin       => 'mojo';
has priority     => 1000;
has title        => sub ($self) { $self->name || $self->id };
has type         => sub ($self) { croak '"type" cannot be built' };
has units        => '#';
has update_every => sub ($self) { $ENV{NETDATA_UPDATE_EVERY} || 1 };

sub data_to_string ($self, $microseconds = undef) {
  my $dimensions = $self->dimensions;
  my $set        = join "\n",
    map { sprintf "SET %s = %s", $_, $dimensions->{$_}{value} // '' } sort keys %$dimensions;

  return !$set ? '' : sprintf "BEGIN %s.%s%s\n%s\nEND\n", $self->type, $self->id,
    ($microseconds ? " $microseconds" : ""), $set;
}

sub dimension ($self, $id, $attrs = undef) {
  return $self->dimensions->{$id} unless $attrs;
  my $dimension = $self->dimensions->{$id} //= {};
  @$dimension{keys(%$attrs)} = values %$attrs;
  return $self;
}

sub to_string ($self) {
  my $dimensions = $self->dimensions;
  return '' unless %$dimensions;

  my $str = sprintf "CHART %s.%s %s\n", $self->type, $self->id,
    q('name' 'title' 'units' family context chart_type priority update_every 'options' 'plugin' 'module')
    =~ s!([a-z_]+)!{$self->$1}!ger;

  for my $id (sort keys %$dimensions) {
    my $dimension = $dimensions->{$id};
    $dimension->{algorithm}  ||= 'absolute';
    $dimension->{divisor}    ||= 1;
    $dimension->{multiplier} ||= 1;
    $dimension->{name}       ||= $id;
    $dimension->{options}    ||= '';
    $str .= sprintf "DIMENSION %s %s\n", $id,
      q('name' algorithm multiplier divisor 'options') =~ s!([a-z_]+)!{$dimension->{$1}}!ger;
  }

  return $str;
}

1;
