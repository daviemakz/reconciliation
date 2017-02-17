package Trade;
use strict;
use warnings;
use base qw(Class::Accessor);
use feature qw(say);
Trade->mk_accessors(qw( type reference security quantity parent ));

sub new {
  my ( $class_name, $details ) = @_;
  my $self;

  # base attributes
  $self = {
    type => '',
    reference => '',
    security => '',
    quantity => '',
    parent => []
  };

  # apply attributes if present
  $self->{'type'} = $details->{'type'};
  $self->{'reference'} = $details->{'reference'};
  $self->{'security'} = $details->{'security'};
  $self->{'quantity'} = $details->{'quantity'};


  bless( $self, $class_name );

  # function: add parent
  sub add_parent {
    my ($self,$trade_id)  = @_;
    push(@{$self->{'parent'}}, $trade_id);
    return;
  }

  return $self;
}

return 1;
