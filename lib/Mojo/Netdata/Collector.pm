package Mojo::Netdata::Collector;
use Mojo::Base 'Mojo::EventEmitter', -signatures;

use Carp qw(croak);
use Mojo::Netdata::Chart;
use Mojo::Promise;
use Time::HiRes qw(time);

has charts       => sub ($self) { +{} };
has context      => 'default';
has type         => sub ($self) { croak '"type" cannot be built' };
has update_every => 1;

sub chart ($self, $id) {
  return $self->charts->{$id}
    //= Mojo::Netdata::Chart->new(context => $self->context, id => $id, type => $self->type);
}

sub recurring_update_p ($self) {
  my $next_time = time + $self->update_every;

  return $self->update_p->then(sub {
    $self->emit_data;
    return Mojo::Promise->timer($next_time - time);
  })->then(sub {
    return $self->recurring_update_p;
  });
}

sub register ($self, $config, $netdata) { }
sub update_p ($self)                    { Mojo::Promise->resolve }

sub emit_data ($self) {
  my @stdout = map { $self->charts->{$_}->data_to_string } sort keys %{$self->charts};
  return $self->emit(stdout => join '', @stdout);
}

sub emit_charts ($self) {
  my @stdout = map { $self->charts->{$_}->to_string } sort keys %{$self->charts};
  return $self->emit(stdout => join '', @stdout);
}

1;
