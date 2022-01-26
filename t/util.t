use Test2::V0;
use Mojo::Netdata::Util qw(safe_id);

subtest safe_id => sub {
  is safe_id('aBC'),        'abc',        'aBC';
  is safe_id('abc.-%{}_X'), 'abc______x', 'abc______X';
};

done_testing;
