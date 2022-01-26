use Test2::V0;
use Mojo::Netdata::Util qw(safe_id);

subtest safe_id => sub {
  is safe_id('abc'),        'abc',        'abc';
  is safe_id('abc.-%{}_x'), 'abc______x', 'abc______x';
};

done_testing;
