package Mojo::Netdata::Collector::HTTP;
use Mojo::Base 'Mojo::Netdata::Collector', -signatures;

use Mojo::UserAgent;
use Mojo::Netdata::Util qw(safe_id);
use Time::HiRes qw(time);

has context => 'web';
has type    => 'http';
has ua      => sub { Mojo::UserAgent->new; };
has _jobs   => sub ($self) { +[] };

sub register ($self, $config, $netdata) {
  $self->_add_jobs_for_site($_) for @{$config->{sites}};
  return undef unless @{$self->_jobs};
  $self->ua->proxy->detect;
  return $self;
}

sub update_p ($self) {
  my ($ua, @p) = ($self->ua);

  my $t0 = time;
  for my $job (@{$self->_jobs}) {
    my $id     = $job->[0];
    my $charts = $job->[1];
    push @p, $ua->start_p($ua->build_tx(@{$job->[2]}))->then(sub ($tx) {
      $charts->{code}->dimension($id => {value => $tx->res->code});
      $charts->{time}->dimension($id => {value => int(1000 * (time - $t0))});
    })->catch(sub ($err) {
      $charts->{code}->dimension($id => {value => 0});
      $charts->{time}->dimension($id => {value => int(1000 * (time - $t0))});
    });
  }

  return Mojo::Promise->all(@p);
}

sub _add_jobs_for_site ($self, $site) {
  my $url = Mojo::URL->new($site->{url} // '');
  return unless my $host = $url->host;

  my $method  = $site->{method} || 'GET';
  my %headers = %{$site->{headers} || {}};
  my $id      = safe_id $url =~ s!https?://!!r;
  my %charts;

  $charts{code} = $self->chart("${id}_code")->title("Status code from $host")->units('#')
    ->dimension(url => {name => $host})->family($host);
  $charts{time} = $self->chart("${id}_time")->title("Response time for $host")->units('ms')
    ->dimension(url => {name => $host})->family($host);

  my @body
    = exists $site->{json} ? (json => $site->{json})
    : exists $site->{form} ? (form => $site->{form})
    : exists $site->{body} ? ($site->{body})
    :                        ();

  push @{$self->_jobs}, ['url', \%charts, [$method => "$url", {%headers}, @body]];

  if ($site->{direct_ip}) {
    $charts{code}->dimension(direct_ip => {name => $site->{direct_ip}});
    $charts{time}->dimension(direct_ip => {name => $site->{direct_ip}});
    $headers{Host} = $host;
    my $direct_url = $url->clone->host($site->{direct_ip});
    push @{$self->_jobs}, ['direct_ip', \%charts, [$method => "$direct_url", {%headers}, @body]];
  }
}

1;
