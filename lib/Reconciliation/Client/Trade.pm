package Trade;
use strict;
use warnings;
use base qw(Class::Accessor);
use feature qw(say);
Trade->mk_accessors(qw( type reference security quantity parent ));

sub new {
  my ( $class_name, $details ) = @_;
  my $self = $details;
  bless( $self, $class_name );
  return $self;
}

return 1;
