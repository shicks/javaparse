# Java::Tree::Import

package Java::Tree::Import;

# Usage: Java::Tree::Import->new(import_decl)
sub new {
  bless {
      'static' => !!$_[1]->{'static'},
      'wildcard' => !!$_[1]->{'import_wildcard'},
      'name' => $_[1]->{'qualified_identifier'}
  }, $_[0];
}

sub isWildcard { $_[0]->{'wildcard'} }

sub isStatic { $_[0]->{'static'} }

sub name { $_[0]->{'name'} }

1
