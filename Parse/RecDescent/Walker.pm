# Parse::RecDescent::Walker
# Walks Parse::RecDescent trees.

use strict;

package Parse::RecDescent::Walker;

# Usage: Parse::RecDescent::Walker->walk($tree, [$object]);
sub walk {
  my $walker = bless {'target' => $_[2], 'seen' => {}}, $_[0];
  return $walker->walk_($_[1], '\$tree');
}

sub walk_ {
  require Scalar::Util;
  my ($self, $tree, $prefix) = @_;
  my $format = $self->format_refaddr_($tree);
  return $self->{'seen'}->{$format} if exists $self->{'seen'}->{$format};
  my $type = Scalar::Util::reftype($tree) || '';
  my $rule = $type eq 'HASH' ? $tree->{'__RULE__'} : '';
  my $rv = $tree;
  if ($type eq 'ARRAY') {
    my $i = 0;
    my @proto = map {
      my $newprefix = "$prefix\[$i\]"; $i++; $self->walk_($_, $newprefix);
    } @$tree;
    $rv = $self->wrap_($rule, \@proto);
    $self->{'seen'}->{$format} = $rv;
  } elsif ($type eq 'HASH') {
    my %proto = map { $self->consolidate_($_, $tree->{$_}, $prefix) } keys %$tree;
    $rv = $self->wrap_($rule, \%proto);
    $self->{'seen'}->{$format} = $rv;
  }
  return $rv;
}

sub wrap_ {
  my ($self, $rule, $ref) = @_;
  my $target = $self->{'target'};
  return ($target and $target->can($rule)) ? $target->$rule($ref) : $ref;
}

sub format_refaddr_ {
  require Scalar::Util;
  pack "J", Scalar::Util::refaddr($_[1]);
}

sub consolidate_ {
  my ($self, $key, $val, $prefix) = @_;

  #return () if $key =~ /DIRECTIVE/;
  if ($key =~ /(\w+)\(\?\)$/) {
    my $rule = $1;
    return () unless @$val;
    return $rule, $self->walk_($val->[0], "$prefix\{$key\}");
  }

  return ($key, $self->walk_($val, "$prefix\{$key\}"));
}

1
