use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile( NAME          => 'Reconciliation',
               AUTHOR        => 'David Makuni <d.makuni@live.co.uk>',
               VERSION       => '1.0.0',
               ABSTRACT      => 'Processes reconciliation of trades between two clients.',
               PL_FILES      => {},
               LICENSE       => 'gpl',
               PREREQ_PM     => {
                'FindBin' => 0,
                'File::Spec' => 0,
                'Text::CSV' => 0,
                'Cwd' => 0,
               },
               TEST_REQUIRES => { 'Test::More' => 0, },
               EXE_FILES     => ['bin/start'],
               test          => { TESTS => 't/*.t' },
             );
