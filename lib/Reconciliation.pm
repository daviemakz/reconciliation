package Reconciliation;
use strict;
use warnings;
use feature qw(say);
use Reconciliation::Client;

sub new {
  my ( $class_name, $details ) = @_;
  my $self = {};
  bless( $self, $class_name );

  # build base attributes
  $self->{'clients'}        = {};
  $self->{'all_securities'} = [];

  # build client data
  foreach my $client ( @{ $details->{'clients'} } ) {
    $self->{'clients'}->{$client} = Client->new( { name => $client } );
  }

  # build full securities list
  $self->{'all_securities'} = _get_securities( $self->{'clients'} );

  # add client names
  $self->{'client_names'} = $details->{'clients'};

  # function: begin checking trades of both clients
  sub start_checks {
    my $self = shift;

    # check each unique security
    foreach my $security_ref ( @{ $self->{'all_securities'} } ) {

      # format trade information to process
      my $clients = {};
      $clients->{$security_ref} = [];
      foreach my $client ( @{ $self->{'client_names'} } ) {
        push( @{ $clients->{$security_ref} },
              { name               => $client,
                info               => $self->{'clients'}->{$client}->{'_trades_linked'}{$security_ref},
                internal_reference => $self->{'clients'}->{$client}->get_trade_sec_int($security_ref),
              } );
      }

      # client 1 : prepare data
      my $client1_trade        = $clients->{$security_ref}[0]->{'info'}->{'T'};
      my $client1_trade_count  = scalar( @{$client1_trade} );
      my $client1_return       = $clients->{$security_ref}[0]->{'info'}->{'R'};
      my $client1_return_count = scalar( @{$client1_return} );
      my $client1_name         = $clients->{$security_ref}[0]->{'name'};
      my $client1_int_ref      = $clients->{$security_ref}[0]->{'internal_reference'};

      # client 2 : prepare data
      my $client2_trade        = $clients->{$security_ref}[1]->{'info'}->{'T'};
      my $client2_trade_count  = scalar( @{$client2_trade} );
      my $client2_return       = $clients->{$security_ref}[1]->{'info'}->{'R'};
      my $client2_return_count = scalar( @{$client2_return} );
      my $client2_name         = $clients->{$security_ref}[1]->{'name'};
      my $client2_int_ref      = $clients->{$security_ref}[1]->{'internal_reference'};

      # declare variables
      my $quantity_return_lowest;
      my $quantity_return_highest;
      my $quantity_trade_lowest;
      my $quantity_trade_highest;

      # check missing trades
      _missing_trade( $client1_name, @{$client2_trade}[0], $security_ref )
          if ( $client1_trade_count < $client2_trade_count );
      _missing_trade( $client2_name, @{$client1_trade}[0], $security_ref )
          if ( $client1_trade_count > $client2_trade_count );

      # check missing returns
      _missing_return( $client1_name, @{$client2_return}[0], $client1_int_ref )
          if ( $client1_return_count < $client2_return_count );
      _missing_return( $client2_name, @{$client1_return}[0], $client2_int_ref )
          if ( $client1_return_count > $client2_return_count );

      # find highest/lowest return quantities
      $quantity_return_lowest = @{$client1_return}[0] < @{$client2_return}[0] ? @{$client1_return}[0] : @{$client2_return}[0]
          if ( ( @{$client2_return}[0] ) && ( @{$client1_return}[0] ) );
      $quantity_return_highest = @{$client1_return}[0] < @{$client2_return}[0] ? @{$client2_return}[0] : @{$client1_return}[0]
          if ( ( @{$client1_return}[0] ) && ( @{$client2_return}[0] ) );

      # check return quantity matches
      _incorrect_return_quantity( $client1_name, $quantity_return_highest, $quantity_return_lowest, $client1_int_ref )
          if (    ( @{$client2_return}[0] )
               && ( @{$client1_return}[0] ) )
          && ( @{$client2_return}[0] != @{$client1_return}[0] );
      _incorrect_return_quantity( $client2_name, $quantity_return_highest, $quantity_return_lowest, $client2_int_ref )
          if (    ( @{$client1_return}[0] )
               && ( @{$client2_return}[0] ) )
          && ( @{$client1_return}[0] != @{$client2_return}[0] );

      # find highest/lowest trade quantities
      $quantity_trade_lowest = @{$client1_trade}[0] < @{$client2_trade}[0] ? @{$client1_trade}[0] : @{$client2_trade}[0]
          if ( ( @{$client2_trade}[0] ) && ( @{$client1_trade}[0] ) );
      $quantity_trade_highest = @{$client1_trade}[0] < @{$client2_trade}[0] ? @{$client2_trade}[0] : @{$client1_trade}[0]
          if ( ( @{$client1_trade}[0] ) && ( @{$client2_trade}[0] ) );

      # check trade quantity match
      _incorrect_trade_quantity( $client1_name, $quantity_trade_highest, $quantity_trade_lowest, $security_ref )
          if (    ( @{$client2_trade}[0] )
               && ( @{$client1_trade}[0] ) )
          && ( @{$client2_trade}[0] != @{$client1_trade}[0] );
      _incorrect_trade_quantity( $client2_name, $quantity_trade_highest, $quantity_trade_lowest, $security_ref )
          if (    ( @{$client1_trade}[0] )
               && ( @{$client2_trade}[0] ) )
          && ( @{$client1_trade}[0] != @{$client2_trade}[0] );

    }

    return;
  }

  return $self;
}

sub _get_securities {
  my $self = shift;
  my @securities_list;
  while ( my ( $key, $value ) = each %{$self} ) {
    push( @securities_list, $value->get_securities_unique() );
  }
  @securities_list = _get_uniq_array(@securities_list);
  return \@securities_list;
}

sub _get_uniq_array {
  my %seen;
  grep !$seen{$_}++, @_;
}

sub _missing_return {
  my ( $name, $quantity, $ref ) = @_;
  say "Client " . uc($name) . " is missing a return for " . $quantity . " on position " . $ref . ".";
  return;
}

sub _incorrect_return_quantity {
  my ( $name, $quantity_correct, $quantity_wrong, $ref ) = @_;
  say "Client " . uc($name) . " has a quantity of " . $quantity_wrong . " on return " . $ref . ":1 that should be " . $quantity_correct . ".";
}

sub _missing_trade {
  my ( $name, $quantity, $sec ) = @_;
  say "Client " . uc($name) . " is missing a trade of " . $quantity . " for security " . $sec . ".";
  return;
}

sub _incorrect_trade_quantity {
  my ( $name, $quantity_correct, $quantity_wrong, $sec ) = @_;
  say "Client " . uc($name) . " has a quantity of " . $quantity_wrong . " on security " . $sec . " that should be " . $quantity_correct . ".";
}

return 1;
