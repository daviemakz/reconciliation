package Trade;
use strict;
use warnings;

sub new {
  my ( $class_name, $details ) = @_;
  my $self = {};
  bless( $self, $class_name );

  # base attributes
  $self = { type      => '',
            reference => '',
            security  => '',
            quantity  => '',
          };

  # apply base attributes
  $self->{'type'}      = $details->{'type'};
  $self->{'reference'} = $details->{'reference'};
  $self->{'security'}  = $details->{'security'};
  $self->{'quantity'}  = $details->{'quantity'};

  return $self;
}

return 1;
