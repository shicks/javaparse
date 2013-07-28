# Java::Tree::QualifiedIdentifier

package Java::Tree::QualifiedIdentifier;

# Usage: Java::Tree::QualifiedIdentifier->new(names)
sub new {
  bless {'names' => $_[1]}, $_[0];
}

use overload fallback => 1,
  '""' => sub { join '.', @{$_[0]->{'names'}} };

sub isQualified { $#{$_[0]->{'names'}} > 0 }

sub names { @{$_[0]->{'names'}} }

sub last_name { $_[0]->{'names'}->[$#{$_[0]->{'names'}}] }

1
