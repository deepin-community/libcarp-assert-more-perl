package main;

use 5.10.0;

use strict;
use warnings;
use ExtUtils::MakeMaker;

my %parms = (
    NAME                => 'Carp::Assert::More',
    VERSION_FROM        => 'More.pm', # finds $VERSION

    PM => {
        'More.pm'       => '$(INST_LIB)/Carp/Assert/More.pm',
    },

    PREREQ_PM   => {
        Carp                => 0,
        'Scalar::Util'      => 0,
        'Test::Exception'   => 0,
        'Test::More'        => 0.18,
    },

    dist => {
        COMPRESS        => 'gzip -9',
        SUFFIX          => '.gz',
        DIST_DEFAULT    => 'all tardist',
    },
);

if ( $ExtUtils::MakeMaker::VERSION =~ /^\d\.\d\d$/ and $ExtUtils::MakeMaker::VERSION > 6.30 ) {
    $parms{LICENSE} = 'artistic_2';
}

if ( $ExtUtils::MakeMaker::VERSION ge '6.46' ) {
    $parms{META_MERGE} = {
        resources => {
            bugtracker  => 'https://github.com/petdance/carp-assert-more/issues',
            repository  => 'git@github.com:petdance/carp-assert-more.git',
            license     => 'https://opensource.org/licenses/artistic-license-2.0.php',
        }
    };
}

WriteMakefile( %parms );

package MY;

sub MY::postamble {
    my $postamble = <<'MAKE_FRAG';
.PHONY: critic tags

critic:
	perlcritic -1 -q -profile perlcriticrc More.pm t/*.t

tags:
	ctags -f tags --recurse --totals \
		--exclude=blib \
		--exclude=.git \
		--exclude='*~' \
		--languages=Perl --langmap=Perl:+.t \

MAKE_FRAG

    return $postamble;
}

1;
