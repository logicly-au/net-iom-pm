package MYAML;

use YAML;

use Carp;
our $AUTOLOAD;  # it's a package global

sub thaw {
    my ($string) = shift;
    
    warn "Thawing\n$string";
    
    $string =~ s/\000//sg;
    
    return Load($string);
}

sub Load {
    warn "load";
}

sub Dump {
    warn "dump";
}

sub freeze {
    my ($string) = shift;
    
    warn "Freezing\n$string\n";
    
    return "$string\r\n";
}

1;