package Client;
use strict;
use warnings;
use base qw(Class::Accessor);
use feature qw(say);
use Text::CSV;
Client->mk_accessors(qw( name ));


sub new {
  my ( $class_name, $details ) = @_;
  my $self = $details;
  bless( $self, $class_name );

  # build base attributes
  $self->{'_trades'} = _get_trades($self->{'name'});

  return $self;
}

sub _get_trades {
  my $file = shift;

  # parse settings
  my $csv = Text::CSV->new ({
       escape_char         => '"',
       sep_char            => '\t',
       eol                 => $\,
       binary              => 1,
       blank_is_undef      => 1,
       empty_is_undef      => 1,
       });

  # open file handle
  open ($file, "<", "tabfile.txt") or die "cannot open: $!";

  # process the file
  while (my $row = $csv->getline($file)) {
    say @$row[0];
  }

  # close file handle
  close($file);

  return 1;
}

return 1;
