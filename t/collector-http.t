use Test2::V0;
use Mojo::Netdata;
use Mojo::Netdata::Collector::HTTP;

subtest 'basics' => sub {
  my $collector = Mojo::Netdata::Collector::HTTP->new;
  is $collector->context, 'web',  'context';
  is $collector->type,    'http', 'type';
};

subtest 'register and run' => sub {
  my %config = (
    class => 'Mojo::Netdata::Collector::HTTP',
    sites => [{url => 'http://example.com', direct_ip => '93.184.216.34'}]
  );

  open my $FH, '>', \(my $stdout = '');
  my $netdata   = Mojo::Netdata->new(stdout => $FH)->config({collectors => [\%config]});
  my $collector = $netdata->collectors->[0];
  ok $collector, 'got collector';

  $collector->emit_charts;
  is $stdout, <<"HERE", 'charts';
CHART http.example_com_code '' 'Status code from example.com' '#' example.com web line 1000 1 '' 'mojo' 'mojo_netdata_collector_http'
DIMENSION direct_ip '93.184.216.34' absolute 1 1 ''
DIMENSION url 'example.com' absolute 1 1 ''
CHART http.example_com_time '' 'Response time for example.com' 'ms' example.com web line 1000 1 '' 'mojo' 'mojo_netdata_collector_http'
DIMENSION direct_ip '93.184.216.34' absolute 1 1 ''
DIMENSION url 'example.com' absolute 1 1 ''
HERE

  $collector->update_p->wait;
  $collector->emit_data;

  like $stdout, qr{BEGIN http\.example_com_code.*SET direct_ip = \d+.*SET url = \d+.*END}s,
    'emit_data code';
  like $stdout, qr{BEGIN http\.example_com_time.*SET direct_ip = \d+.*SET url = \d+.*END}s,
    'emit_data time';

  note $stdout;
};

done_testing;
