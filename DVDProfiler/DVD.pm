package Net::DVDProfiler::DVD;

sub new {
  my $ref = shift;
  my $class = ref( $ref ) || $ref;

  my $self = bless {
    title => undef,
    upc => undef,
    @_
  }, $class;

  return $self;
}

sub title {
  return $_[0]->{title};
}

sub upc {
  return $_[0]->{upc};
}
1;
