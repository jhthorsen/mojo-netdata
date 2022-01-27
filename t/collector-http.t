use Test2::V0;
use Mojo::Netdata;
use Mojo::Netdata::Collector::HTTP;

subtest 'basics' => sub {
  my $collector = Mojo::Netdata::Collector::HTTP->new;
  is $collector->context,      'web',  'context';
  is $collector->type,         'http', 'type';
  is $collector->update_every, 30,     'update_every';
};

subtest 'register and run' => sub {
  my $direct_ip = '93.184.216.34';
  my %config    = (
    class => 'Mojo::Netdata::Collector::HTTP',
    jobs  => {
      'http://nope.localhost' => {},
      'http://example.com'    => {group => 'Test Group', direct_ip => $direct_ip},
    },
  );

  open my $FH, '>', \(my $stdout = '');
  my $netdata
    = Mojo::Netdata->new(stdout => $FH, update_every => 10)->config({collectors => [\%config]});
  my $collector = $netdata->collectors->[0];
  ok $collector, 'got collector';
  is $collector->update_every, 10, 'update_every from netdata';

  $collector->emit_charts;
  is $stdout, <<"HERE", 'charts';
CHART http.test_group_code '' 'HTTP Status code for Test Group' '#' $direct_ip web line 1000 10 '' 'mojo' 'mojo_netdata_collector_http'
DIMENSION example_com 'example.com' absolute 1 1 ''
DIMENSION example_com_direct 'example.com direct' absolute 1 1 ''
CHART http.test_group_time '' 'Response time for Test Group' 'ms' $direct_ip web line 1000 10 '' 'mojo' 'mojo_netdata_collector_http'
DIMENSION example_com 'example.com' absolute 1 1 ''
DIMENSION example_com_direct 'example.com direct' absolute 1 1 ''
CHART http.nope_localhost_code '' 'HTTP Status code for nope.localhost' '#' nope.localhost web line 1000 10 '' 'mojo' 'mojo_netdata_collector_http'
DIMENSION nope_localhost 'nope.localhost' absolute 1 1 ''
CHART http.nope_localhost_time '' 'Response time for nope.localhost' 'ms' nope.localhost web line 1000 10 '' 'mojo' 'mojo_netdata_collector_http'
DIMENSION nope_localhost 'nope.localhost' absolute 1 1 ''
HERE

  $collector->update_p->wait;
  $collector->emit_data;

  like $stdout,
    qr{BEGIN http\.test_group_code.*SET example_com = \d+.*SET example_com_direct = \d+.*END}s,
    'emit_data code';
  like $stdout,
    qr{BEGIN http\.test_group_time.*SET example_com = \d+.*SET example_com_direct = \d+.*END}s,
    'emit_data time';

  like $stdout, qr{BEGIN http\.nope_localhost_code.*SET nope_localhost = 0.*END}s, 'emit_data code';
  like $stdout, qr{BEGIN http\.nope_localhost_time.*SET nope_localhost = \d+.*END}s,
    'emit_data time';

  note $stdout;
};

done_testing;
