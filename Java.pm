use strict;

# ABSTRACT SUPERCLASS

package Java::Node {
  # Java::Node->new(pos, name, [children])
  sub new {
    return bless {'pos' => $_[0], 'name' => $_[1], 'children' => $_[2]}, 'Java::Node';
  }
  sub children {
    return ();
  }
  sub name {
    return $_[0]->{'name'};
  }
  sub position {
    return $_[0]->{'pos'};
  }
  sub children {
    my $children = $_[0]->{'children'};
    return $children ? @$children || ();
  }
}

# TYPE NAMES

package Java::TypeName {
  @ISA = ('Java::Node');
  # Java::TypeName->new(pos, name, [children])
  sub new {
    return bless Java::Node->new($_[0], $_[1], $_[2]), 'Java::TypeName';
  }
  # Java::TypeName->create_reference_type([components])
  sub create_reference_type {
    my @components = @$_[0];
    if ($components[$#components]->children > 0) 
  }
}

package Java::PrimitiveType {
  @ISA = ('Java::TypeName');
  # Java::PrimitiveType->new(pos, name)
  sub new {
    return bless Java::TypeName->new($_[0], $_[1]), 'Java::PrimitiveType';
  }
}

package Java::ArrayType {
  @ISA = ('Java::TypeName');
  # Java::ArrayType->new(pos, TypeName base_type)
  sub new {
    return bless Java::TypeName->new($_[0], $_[1]->name . '[]', [$_[1]]),
        'Java::ArrayType';
  }
}

package Java::WildcardType {
  @ISA = ('Java::TypeName');
  # Java::WildcardType->new(pos, [TypeName extends], [TypeName super])
  sub new {
    my $name = $_[1]->{'extends'} ? '? extends ' + $_[1]->{'extends'}->name
        : $_[1]->{'super'} ? '? super ' + $_[1]->{'super'}->name : '?';
    return bless Java::TypeName->new($_[0], $name,
            Java::util->filter([$_[1]->{'extends'}, $_[1]->{'super'}])),
        'Java::WildcardType';
  }
}

package Java::GenericType {
  @ISA = ('Java::TypeName');
  # Java::GenericType->new(pos, basename, TypeName[] params)
  sub new {
    my $name = $_[1];
    my @children = ();
    if (@$_[2] > 0) {
      $name = "$name<";
      foreach (@$_[2]) {
        $name .= $_->name;
      }
      $name = "$name>";
      push @children, $_;
    }
    return bless Java::TypeName->new($_[0], $name, \@children),
        'Java::GenericType';
  }
}

package Java::CompilationUnit {
  sub imports { return $_[0]->{'imports'}; }
  sub pkg { return $_[0]->{'package'}; }
}

package Java::TypeDecl {
  

}


# UTILITY

package Java::util {
  # Java::util->filter(listref)
  sub filter {
    my @arr = @$_[0];
    @arr = grep { $_ } @arr;
    return \@arr;
  }
}
