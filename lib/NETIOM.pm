# $Id: $

package NETIOM;

use strict;
use warnings;

use YAML;
use LWP::Simple;

use Carp;

# use Data::Dumper;

sub new {

    my $class     = shift;
    my $unit_name = shift;

    my $self;

    $self->{unit_name} = $unit_name;
    $self->{unit_uri}  = "http://$unit_name/client.cgi";

    if ( _get_set_unit_state($self) ) {

        return bless $self, $class;

    }
    else {
        croak "Could not determine state of NET-IOM unit at $unit_name.";
    }
}

sub get_output {
    my $self = shift;

    return split //, $self->get_output_bitmap();
}

sub set_output {
    my $self     = shift;
    my @bitarray = @_;

    if ( scalar @bitarray != 16 ) {
        croak "You must supply 16 bits.";
    }

    my $bit_n = 1;
    foreach my $bit (@bitarray) {
        $self->set_output_bit( $bit_n++, $bit );
    }

    return $self->get_output();
}

sub get_output_bitmap {
    my $self = shift;
    
    $self->_get_set_unit_state();

    return $self->{state}{digital}{output}{bitmap};

}

sub set_output_bitmap {
    my $self      = shift;
    my $bitstring = shift;

    return join '', $self->set_output( split //, $bitstring );

}

sub get_output_bitmap_int {
    my $self = shift;

    return _netiom_output_to_int( $self->get_output_bitmap() );

}

sub set_output_bitmap_int {
    my $self = shift;

    croak "Not implemented.";

}

sub get_output_bit {
    my $self   = shift;
    my $output = shift;

    my @output_array = split //, $self->get_output_bitmap();

    if ($output) {
        return $output_array[ $output - 1 ];
    }
    else {
        return @output_array;
    }
}

sub set_output_bit {
    my $self         = shift;
    my $output       = shift;
    my $set_to_state = shift;

    my $action;
    if ($set_to_state) {
        $set_to_state = 1;
        $action       = 'A';
    }
    else {
        $set_to_state = 0;
        $action       = 'B';
    }

    $output = sprintf( "%02d", $output );

    my $params = "$action$output=$set_to_state";

    $self->_get_set_unit_state($params);

    return $self->get_output_bit($output);
}

sub get_input_bitmap {
    my $self = shift;
    
    $self->_get_set_unit_state();

    return $self->{state}{digital}{input}{bitmap};

}

sub get_input_bitmap_int {
    my $self = shift;

    return _netiom_output_to_int( $self->get_input_bitmap() );

}

sub get_input {
    my $self = shift;

    return split //, $self->get_input_bitmap();

}

sub get_input_bit {
    my $self  = shift;
    my $input = shift;

    return ( $self->get_input() )[ $input - 1 ];

}

sub get_analogue_input {
    my $self     = shift;
    my $input_no = shift;
    
    $self->_get_set_unit_state();

    if ( !$input_no ) {
        return (
            $self->get_analogue_input(1), $self->get_analogue_input(2),
            $self->get_analogue_input(3), $self->get_analogue_input(4),
        );
    }
    elsif ( $input_no < 1 or $input_no > 4 ) {
        croak('Analogue inputs numbers are 1 through 4 only.');
    }
    else {
        return $self->{state}{analogue}{input}{$input_no};
    }
}

sub get_serial {
    my $self = shift;

    $self->_get_set_unit_state();

    return $self->{state}{serial}{input}{text};
}

sub set_serial {
    my $self = shift;
    
    $self->_get_set_unit_state();

    croak "Not implemented.";
}

sub get_unit_name {
    my $self = shift;

    return $self->{unit_name};
}

sub _get_set_unit_state {

    my $self         = shift;
    my $param_string = shift;

    my $uri = $self->{unit_uri};
    if ($param_string) {
        $uri .= "?$param_string";
    }

    if ( my $state = _process_client_yaml( get($uri) ) ) {

        $self->{state} = $state;

    }
    else {

        croak
"Did not get response from NET-IOM unit $self->{unit_name} when getting/setting state.";

    }

    return 1;
}

# Turns a string from the net-iom device representing the current output
# into an integer with those bits set
sub _netiom_output_to_int {

    my $bitstring = shift;

    # We reverse the string, as NET-IOM sends it with LSB first, then we
    # pack() to turn 16 bytes (each byte is either ascii '0' or '1') into a
    # 2 byte wide bitstring, and then use vec() to convert that bitstring
    # into a normal integer.
    return vec( pack( "B16", scalar( reverse($bitstring) ) ), 0, 16 );
}

sub _process_client_yaml {

    my $yaml = shift;

    if ( !$yaml ) {
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
