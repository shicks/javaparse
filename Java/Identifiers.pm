# Java::Identifiers
# Walks a Java compilation unit to pull out imported, declared, and used types.

package Java::Identifiers {
  sub identifier {
    return $_[1]->{'__PATTERN1__'};
  }
  sub qualified_identifier {
    return join '.', @{$_[1]->{'identifier(s)'}};
  }
  sub package_decl {
    $_[0]->{'package'} = $_[1]->{'qualified_identifier'};
    return {};
  }
  sub import_decl {
    my $import = {'name' => $_[1]->{'qualified_identifier'}};
    $import->{'static'} = !!$_[1]->{'static'};
    $import->{'wildcard'} = !!$_[1]->{'import_wildcard'};
    push @{$_[0]->{'imports'}}, $import;
    $import->{'name'} =~ /\.([^.]*)$/;
    my $unqualified = $1;
    if ($import->{'static'}) {
      $_[0]->{'imported primaries'}->{$unqualified} = 1;  
      $_[0]->{'imported methods'}->{$unqualified} = 1;  
    } else {
      $_[0]->{'imported types'}->{$unqualified} = 1;  
    }
    # What to do with wildcards?
    return {};
  }
  sub reference_type_component {
    return $_[1]->{'identifier'};
  }
  sub reference_type {
    my $type = join '.', @{$_[1]->{'reference_type_component(s)'}};
    $_[0]->{'types'}->{$type} = 1;
    return $_[1];
  }
  sub created_name_component {
    return $_[1]->{'identifier'};
  }
  sub created_name {
    my $type = join '.', @{$_[1]->{'created_name_component(s)'}};
    $_[0]->{'types'}->{$type} = 1;
    return $_[1];
  }
  sub annotation {
    $_[0]->{'types'}->{$_[1]->{'qualified_identifier'}} = 1;
    return $_[1];
  }
  sub type_parameter {
    $_[0]->{'imported types'}->{$_[1]->{'identifier'}} = 1;
    return $_[1];
  }
  sub variable_decl_id {
    $_[0]->{'imported primaries'}->{$_[1]->{'identifier'}} = 1;
    return $_[1];
  }
  sub class_decl {
    $_[0]->{'imported types'}->{$_[1]->{'identifier'}} = 1;
    $_[0]->{'imported primaries'}->{$_[1]->{'identifier'}} = 1;
    return $_[1];
  }
  sub enum_decl {
    $_[0]->{'imported types'}->{$_[1]->{'identifier'}} = 1;
    $_[0]->{'imported primaries'}->{$_[1]->{'identifier'}} = 1;
    return $_[1];
  }
  sub interface_decl {
    $_[0]->{'imported types'}->{$_[1]->{'identifier'}} = 1;
    $_[0]->{'imported primaries'}->{$_[1]->{'identifier'}} = 1;
    return $_[1];
  }
  sub annotation_decl {
    $_[0]->{'imported types'}->{$_[1]->{'identifier'}} = 1;
    $_[0]->{'imported primaries'}->{$_[1]->{'identifier'}} = 1;
    return $_[1];
  }
  sub method_decl {
    $_[0]->{'imported methods'}->{$_[1]->{'identifier'}} = 1;
    return $_[1];
  }
  sub interface_method_decl {
    $_[0]->{'imported methods'}->{$_[1]->{'identifier'}} = 1;
    return $_[1];
  }
  sub primary {
    my $egis = $_[1]->{'explicit_generic_invocation_suffix'};
    my $ident = $_[1]->{'identifier(s)'};
    my $is = $_[1]->{'identifier_suffix'};
    if ($egis && $egis->{'identifier'}) {
      $_[0]->{'methods'}->{$egis->{'identifier'}} = 1;
    } elsif ($ident) {
      if (not $is or $is->{'array_index'}) {
        $_[0]->{'primaries'}->{$ident->[0]} = 1;
      } elsif ($is->{'class'}) {
        $_[0]->{'types'}->{$ident->[0]} = 1;
      } elsif ($is->{'arguments'}) {
        # ACK! can't tell if the base is a primary or a type... we could
        # keep better track of whether things are imported static or not.
        my @ident = @$ident;
        if (@ident > 1) {
          $_[0]->{'types'}->{$ident[0]} = 1;
          $_[0]->{'primaries'}->{$ident[0]} = 1;
        }
        $_[0]->{'methods'}->{$ident[$#ident]} = 1;
      }
    }
    return $_[1];
  }

  sub new {
    return bless {
                  'imports' => [],
                  'types' => {},
                  'methods' => {},
                  'primaries' => {},
                  'imported types' => {},
                  'imported methods' => {},
                  'imported primaries' => {},
                 }, $_[0];
  }
  sub imports {
    return @{$_[0]->{'imports'}};
  }
  sub types {
    return sort keys %{$_[0]->{'types'}};
  }
  sub methods {
    return sort keys %{$_[0]->{'methods'}};
  }
  sub primaries {
    return sort keys %{$_[0]->{'primaries'}};
  }
  sub unimported {
    foreach my $t ('types', 'methods', 'primaries') {
      my @unimported = grep { not $_[0]->{"imported $t"}->{$_} } keys %{$_[0]->{$t}};
      print "UNIMPORTED $t: @unimported\n";
    }
  }
}

1
