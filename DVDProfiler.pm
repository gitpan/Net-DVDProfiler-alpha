package Net::DVDProfiler;

use LWP::UserAgent;
use Net::DVDProfiler::DVD;

sub new {
  my $ref = shift;
  my $class = ref( $ref ) || $ref;

  my $self = bless {
    lwp => new LWP::UserAgent( cookie_jar => {} ),
    alias => undef,
    @_
  }, $class;

  die "DVDProfiler requires an alias." unless ( $self->{alias} );

  $self->{lwp}->get( 'http://www.dvdprofiler.com/mycollection.asp?alias=' . $self->{alias} );
  $self->{lwp}->get( 'http://www.dvdprofiler.com/mycollection.asp?acceptadult=true&alias=' . $self->{alias} );

  return $self;
}

sub getAll {
  return $_[0]->getList( 'A' );
}

sub getOwned {
  return $_[0]->getList( 'O' );
}

sub getOrdered {
  return $_[0]->getList( 'P' );
}

sub getWishlist {
  return $_[0]->getList( 'W' );
}

sub getList {
  my ( $self, $type ) = @_;

  my @upcs;
  my $page = $u->get( 'http://www.dvdprofiler.com/dvdpro/mycollection/styles/Default/list.asp?type=' . $type )->content();

  while ( $page =~ /id="([^"]*)".*?entry">(.*?)<\/A>/g ) {
    push( @upcs, new Net::DVDProfiler::DVD( upc => $1, title => $2 ) );
  }

  return @upcs;
}
1;
