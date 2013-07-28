# Java::Tree::TypeDecl

package Java::Tree::TypeDecl;

# Usage: Java::Tree::TypeDecl->new(
#    type : string,
#    name : string,
#    modifiers : [Modifier],
#    decls : [BodyDecl]
# )
sub new {
  bless {
      'type' => $_[1],
      'name' => $_[2],
      'modifiers' => $_[3],
      'decls' => $_[4],
  }, $_[0];
}

sub name { $_[0]->{'name'} }

sub type { $_[0]->{'type'} }

sub modifiers { @{$_[0]->{'modifiers'}} }

sub decls { @{$_[0]->{'decls'}} }

# $typedecl->set_implements([Type])
sub set_implements {
  $_[0]->{'implements'} = $_[1];
}

# $typedecl->set_extends([Type])
sub set_extends {
  $_[0]->{'extends'} = $_[1];
}

1
