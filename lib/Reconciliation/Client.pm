package Client;
use strict;
use warnings;
use Text::CSV;
use Cwd 'getcwd';
use Reconciliation::Client::Trade;

sub new {
  my ( $class_name, $details ) = @_;
  my $self = $details;
  bless( $self, $class_name );

  # build base attributes
  ( $self->{'_trades'},
    $self->{'_trades_ref'},
    $self->{'_trades_linked'},
    $self->{'_trades_to_int'},
    $self->{'_security_list'} ) = _get_trades( $self->{'name'} );

  # function: get trade internal reference via security identity
  sub get_trade_sec_int {
    my ( $self, $trade_sec ) = @_;
    return $self->{'_trades_to_int'}{$trade_sec};
  }

  # function: get unique securities from client
  sub get_securities_unique {
    my $self = shift;
    return _get_uniq( @{ $self->{'_security_list'} } );
  }

  return $self;
}

sub _get_uniq {
  my %seen;
  grep !$seen{$_}++, @_;
}

sub _get_trades {
  my $name = shift;
  my ( %trades, %trade_ref, %linked_trades, %trades_to_int, @securities );

  # get filename
  my $filename = getcwd($0) . '/eg/' . $name . '_data';

  # parse settings
  my $csv = Text::CSV->new(
                            { escape_char    => '"',
                              sep_char       => "\t",
                              blank_is_undef => 1,
                              empty_is_undef => 1,
                            } );

  # open file handle or return blank data
  open( my $file_contents, "<", $filename )
      or return (
          \%trades,
          \%trade_ref,
          \%linked_trades,
          \%trades_to_int,
          \@securities );

  # process the csv file...
  my $counter = 0;
  while ( my $line = <$file_contents> ) {

    # variables
    $counter++;
    next if $counter <= 1;
    chomp $line;
    my $id = $counter - 1;

    # can we parse this line?
    if ( $csv->parse($line) ) {

      # line fields
      my @line_array = $csv->fields();

      # build trade object
      my $trade = Trade->new(
                              { type      => $line_array[1],
                                reference => $line_array[2],
                                security  => $line_array[3],
                                quantity  => $line_array[4] } );

      # add to securities list
      push( @securities, $line_array[3] );

      # add to reference hash
      $trade_ref{ $line_array[2] } = $id;

      # commit your trade to the object
      $trades{$id} = $trade;

    } else {

      # should not happen in a well formed file
      warn "Line could not be parsed: $line\n";

    }
  }

  # close file handle
  close($file_contents);

  # build trade/return reference hash
  while ( my ( $key, $value ) = each %trades ) {
    $linked_trades{ $trades{$key}->{'security'} }{'T'} = [];
    $linked_trades{ $trades{$key}->{'security'} }{'R'} = [];
  }

  # add quantities of trades/returns to reference hash
  while ( my ( $key, $value ) = each %trades ) {
    if ( $trades{$key}->{'reference'} =~ m/(\w+)(:)(\d+)/ ) {
      push( @{ $linked_trades{ $trades{$key}->{'security'} }{'R'} },
        $trades{$key}->{'quantity'} );
    } else {
      $trades_to_int{ $trades{$key}->{'security'} }
        = $trades{$key}->{'reference'};
      push( @{ $linked_trades{ $trades{$key}->{'security'} }{'T'} },
        $trades{$key}->{'quantity'} );
    }
  }

  # return
  return (
    \%trades,
    \%trade_ref,
    \%linked_trades,
    \%trades_to_int,
    \@securities );
}

return 1;
