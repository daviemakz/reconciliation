use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile( NAME          => 'Reconciliation',
               AUTHOR        => 'David Makuni <d.makuni@live.co.uk>',
               VERSION       => '1.0.0',
               ABSTRACT      => 'Processes reconciliation between two sets of data',
               PL_FILES      => {},
               LICENSE       => 'gpl',
               PREREQ_PM     => {
                'List::Util' => 0,
                'Class::Accessor' => 0
               },
               TEST_REQUIRES => { 'Test::More' => 0, },
               EXE_FILES     => ['bin/start'],
               test          => { TESTS => 't/*.t' },
             );
