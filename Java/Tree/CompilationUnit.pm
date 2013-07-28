# Java::Tree::CompilationUnit

package Java::Tree::CompilationUnit;

sub new {
  bless {'imports' => {}, 'wildcard_imports' => [], 'decls' => []}, $_[0];
}

# $cu->set_package(QualifiedName)
sub set_package {
  $_[0]->{'package'} = $_[1];
}

# $cu->add_import(Import)
sub add_import {
  if ($_[1]->isWildcard) {
    push @{$_[0]->{'wildcard_imports'}}, $_[1];
  } else {
    $_[0]->{'imports'}->{$_[1]->name->last_name} = $_[1];
  }
}

# $cu->add_decl(TypeDecl)
sub add_decl {
  push @{$_[0]->{'decls'}}, $_[1];
}

1
