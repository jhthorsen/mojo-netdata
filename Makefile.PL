# Generated by git-ship. See 'git-ship --man' for help or https://github.com/jhthorsen/app-git-ship
use utf8;
use ExtUtils::MakeMaker;
my %WriteMakefileArgs = (
  NAME           => 'Mojo::Netdata',
  AUTHOR         => 'Jan Henning Thorsen <jhthorsen@cpan.org>',
  LICENSE        => 'artistic_2',
  ABSTRACT_FROM  => 'lib/Mojo/Netdata.pm',
  VERSION_FROM   => 'lib/Mojo/Netdata.pm',
  EXE_FILES      => [qw(script/mojo-netdata)],
  OBJECT         => '',
  BUILD_REQUIRES => {},
  TEST_REQUIRES  => {'Test2::V0'   => '0.000144'},
  PREREQ_PM      => {'Mojolicious' => '8.71', 'perl' => 'v5.22.0'},
  META_MERGE     => {
    'dynamic_config' => 0,
    'meta-spec'      => {version => 2},
    'resources'      => {
      bugtracker => {web => 'https://github.com/jhthorsen/mojo-netdata/issues'},
      homepage   => 'https://github.com/jhthorsen/mojo-netdata',
      repository => {
        type => 'git',
        url  => 'https://github.com/jhthorsen/mojo-netdata.git',
        web  => 'https://github.com/jhthorsen/mojo-netdata',
      },
    },
    'x_contributors' => ['Jan Henning Thorsen'],
  },
  test => {TESTS => (-e 'META.yml' ? 't/*.t' : 't/*.t xt/*.t')},
);

unless (eval { ExtUtils::MakeMaker->VERSION('6.63_03') }) {
  my $test_requires = delete $WriteMakefileArgs{TEST_REQUIRES};
  @{$WriteMakefileArgs{PREREQ_PM}}{keys %$test_requires} = values %$test_requires;
}

WriteMakefile(%WriteMakefileArgs);
