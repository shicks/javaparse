# Java::Identifiers
# Walks a Java compilation unit to pull out imported, declared, and used types.

package Java::Tree;

require Java::Tree::CompilationUnit;
require Java::Tree::QualifiedIdentifier;
require Java::Tree::Import;
require Java::Tree::TypeDecl;

require Data::Dumper;

sub compilation_unit {
  my $cu = Java::Tree::CompilationUnit->new;
  $cu->set_package($_[1]->{'package_decl'}) if $_[1]->{'package_decl'};
  $cu->add_import($_) foreach @{$_[1]->{'import_decl(s?)'} || []};
  $cu->add_decl($_) foreach @{$_[1]->{'type_decl(s?)'} || []};
  $cu
}

sub identifier { $_[1]->{'__PATTERN1__'} }

sub qualified_identifier { Java::Tree::QualifiedIdentifier->new($_[1]->{'identifier(s)'}) }

sub package_decl { $_[1]->{'qualified_identifier'} }

sub import_decl { Java::Tree::Import->new($_[1]) }

sub type_decl {
  $_[1]->{'class_decl'} || $_[1]->{'interface_decl'}
      || $_[1]->{'enum_decl'} || $_[1]->{'annotation_decl'}
}

sub class_decl {
  my $decl = Java::Tree::TypeDecl->new('class', $_[1]->{'identifier'},
      [], []); # $_[1]->{'modifier(s)'}, $_[1]->{'class_body'}->{'class_body_decl(s)'};
  $decl->set_extends([$_[1]->{'extends_clause'}->{'type'}])
      if $_[1]->{'extends_clause'};
  $decl->set_implements($_[1]->{'implements_clause'}->{'type_list'})
      if $_[1]->{'implements_clause'};
  $decl
}

sub enum_decl { 0 }
sub interface_decl { 0 }
sub annotation_decl { 0 }

sub type_list { $_[1]->{'reference_type(s)'} }

1
