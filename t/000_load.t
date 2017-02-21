#!/usr/bin/perl -w
use FindBin;
use File::Spec;
use lib File::Spec->catdir( $FindBin::Bin, '..', 'lib' );
use Reconciliation;
use Reconciliation::Client;
use Reconciliation::Client::Trade;

use Test::More tests => 3;

BEGIN {
  use_ok('Reconciliation');
  use_ok('Reconciliation::Client');
  use_ok('Reconciliation::Client::Trade');
}

1;
