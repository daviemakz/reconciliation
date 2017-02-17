package Client;
use strict;
use warnings;
use base qw(Class::Accessor);
use feature qw(say);
use Text::CSV;
use File::Spec;
use Cwd 'getcwd';
use Data::Dumper;
use Reconciliation::Client::Trade;
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
  my $name = shift;
  my $filename = getcwd($0) . '/eg/' . $name . '_data';
  my @trades;

  # parse settings
  my $csv = Text::CSV->new ({
    escape_char         => '"',
    sep_char            => '\t',
    eol                 => $\,
    blank_is_undef      => 1,
    empty_is_undef      => 1,
  });

  # open file handle
  open (my $file_contents, "<", $filename) or die "cannot open: $!";

  # close file handle
  close($file_contents);

  return \@trades;
}

return 1;
