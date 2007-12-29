# $Id: $

package NETIOM;

use strict;
use warnings;

use YAML;
use LWP::Simple;

use Carp;

# use Data::Dumper;

sub new {
    
    my $proto     = shift;
    my $unit_name = shift;
    
    if ( my $self = _get_netiom_state( $unit_name ) ) {
        
        return bless $self, $proto;
    
    }
    else {
        croak "Could not determine state of NET-IOM unit at $unit_name.";
    }
}

sub get_output_bitmap {
    my $self = shift;
    
    return $self->{digital}{output}{bitmap};
    
}

sub get_output_bitmap_int {
    my $self = shift;
    
    return _netiom_output_to_int( $self->get_output_bitmap() );
    
}

sub get_input_bitmap {
    my $self = shift;
    
    return $self->{digital}{input}{bitmap};
    
}

sub get_input_bitmap_int {
    my $self = shift;
    
    return _netiom_output_to_int( $self->get_input_bitmap() );
    
}

sub get_analogue_input {
    my $self     = shift;
    my $input_no = shift;
    
    if ( ! $input_no ) {
        return (
            $self->get_analogue_input(1),
            $self->get_analogue_input(2),
            $self->get_analogue_input(3),
            $self->get_analogue_input(4),
        );
    }
    elsif ( $input_no < 1 or $input_no > 4 ) {
        croak('Analogue inputs numbers are 1 through 4 only.')
    }
    else {
        return $self->{analogue}{input}{$input_no};
    }
}

sub get_input_serial {
    my $self = shift;
    
    return $self->{serial}{input}{text};
}

sub get_unit_name {
    my $self = shift;
    
    return $self->{'unit-name'};
}

#        my $netiom_uri = 'http://'
#          . $params->{unit}
#          . '/client.cgi?'
#          . $netiom_param_prefix[$index]
#          . sprintf( "%02d", $params->{output}[$index] ) . '='
#          . $action;

sub _get_netiom_state {

    my $unit_name = shift;

    my $netiom_uri = "http://$unit_name/client.cgi";

    if ( my $state = _process_client_yaml(
            get($netiom_uri)
        )
    ) {

        return $state;
    
    }
    else {
    
        return;
    
    }
}

# Turns a string from the net-iom device representing the current output
# into an integer with those bits set
sub _netiom_output_to_int {
    
    my $bitstring = shift;

    # We reverse the string, as NET-IOM sends it with LSB first, then we
    # pack() to turn 16 bytes (each byte is either ascii '0' or '1') into a 
    # 2 byte wide bitstring, and then use vec() to convert that bitstring
    # into a normal integer.
    return vec(
        pack("B16", 
            scalar(
                reverse($bitstring)
            )
        ),
        0,
        16
    );
}

sub _process_client_yaml {

    my $yaml = shift;
    
    if ( ! $yaml ) {
        return;
    }

    my $netiom_state;

    $yaml =~ s/\n\.\.\..*/\n/sg;
    $yaml =~ s/\000//sg;

    eval { $netiom_state = Load($yaml); };
    if ($@) {
        warn "$@\n";
        warn "$yaml\n";
        return;
    }

    # warn Dumper $data;

    return $netiom_state;
}

1;