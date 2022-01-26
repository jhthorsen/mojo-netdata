use Test2::V0;
use Mojo::Netdata::Chart;

subtest 'basics' => sub {
  my $chart = Mojo::Netdata::Chart->new;

  is $chart->chart_type,     'line',    'chart_type';
  is $chart->context,        'default', 'context';
  is $chart->dimensions, {}, 'dimensions';
  is $chart->module,         '',     'module';
  is $chart->name,           '',     'name';
  is $chart->options,        '',     'options';
  is $chart->plugin,         'mojo', 'plugin';
  is $chart->priority,       1000,   'priority';
  is $chart->units,          '#',    'units';
  is $chart->update_every,   1,      'update_every';

  eval { $chart->family };
  like $@, qr{"id" cannot}, 'family';

  eval { $chart->id };
  like $@, qr{"id" cannot}, 'id';

  eval { $chart->title };
  like $@, qr{"id" cannot}, 'title';

  eval { $chart->type };
  like $@, qr{"type" cannot}, 'type';

  $chart->id('foo')->type('bar');
  is $chart->family, 'foo', 'family';
  is $chart->id,     'foo', 'id';
  is $chart->title,  'foo', 'title';
  is $chart->type,   'bar', 'type';
};

subtest 'to_string' => sub {
  my $chart = Mojo::Netdata::Chart->new(id => 'foo', module => 'm1', type => 'bar');
  is $chart->to_string, '', 'without any dimensions';

  $chart->dimensions({
    a => {},
    b => {algorithm => 'incremental', name => 'B', divisor => 2, multiplier => 3, options => 'x y'}
  });
  is $chart->to_string, <<'HERE', 'with dimensions';
CHART bar.foo '' 'foo' '#' foo default line 1000 1 '' 'mojo' 'm1'
DIMENSION a 'a' absolute 1 1 ''
DIMENSION b 'B' incremental 3 2 'x y'
HERE
};

subtest 'data_to_string' => sub {
  my $chart = Mojo::Netdata::Chart->new(dimensions => {x => {}}, id => 'foo', type => 'bar');

  is $chart->data_to_string, <<'HERE', 'no value';
BEGIN bar.foo
SET x = 
END
HERE

  $chart->dimensions->{x}{value} = 42;
  is $chart->data_to_string, <<'HERE', 'with value';
BEGIN bar.foo
SET x = 42
END
HERE

  $chart->dimensions->{x}{value} = 0;
  is $chart->data_to_string(1002), <<'HERE', 'with microseconds';
BEGIN bar.foo 1002
SET x = 0
END
HERE
};

done_testing;