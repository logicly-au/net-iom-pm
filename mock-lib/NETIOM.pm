# $Id: $

package NETIOM;

use strict;
use warnings;

use Carp;
use DBI;

# use Data::Dumper;

sub new {

    my $class     = shift;
    my $unit_name = shift;

    my $self;

    $self->{unit_name} = $unit_name;
    
    my $dbfile = "net-iom.db";
    if ( exists $ENV{NET_IOM_DB_PATH} ) {
        if ( ! -d $ENV{NET_IOM_DB_PATH} ) {
            die $ENV{NET_IOM_DB_PATH} . " is not a directory, exiting.\n";
        }
        
        $dbfile = $ENV{NET_IOM_DB_PATH} . "/net-iom.db";
    }
    
    my $create_db = ( ! -f $dbfile );
    
    my $dbh = DBI->connect("dbi:SQLite:dbname=$dbfile","","");
    
    if ( $create_db ) {
        $dbh->do( 
            q( 
                create table unit_state (
                    unit text primary_key,
                    input01,
                    input02,
                    input03,
                    input04,
                    input05,
                    input06,
                    input07,
                    input08,
                    input09,
                    input10,
                    input11,
                    input12,
                    input13,
                    input14,
                    input15,
                    input16,
                    output01,
                    output02,
                    output03,
                    output04,
                    output05,
                    output06,
                    output07,
                    output08,
                    output09,
                    output10,
                    output11,
                    output12,
                    output13,
                    output14,
                    output15,
                    output16,
                    analogue1,
                    analogue2,
                    analogue3,
                    analogue4,
                    serial
                )
            )
        );
    };
    
    if ( ! $dbh->selectrow_array("select count(*) from unit_state where unit = ?", {}, ($unit_name)) ) {
        $dbh->do( 
            q( 
                insert into unit_state (
                    unit, 
                    input01,
                    input02,
                    input03,
                    input04,
                    input05,
                    input06,
                    input07,
                    input08,
                    input09,
                    input10,
                    input11,
                    input12,
                    input13,
                    input14,
                    input15,
                    input16,
                    output01,
                    output02,
                    output03,
                    output04,
                    output05,
                    output06,
                    output07,
                    output08,
                    output09,
                    output10,
                    output11,
                    output12,
                    output13,
                    output14,
                    output15,
                    output16,
                    analogue1,
                    analogue2,
                    analogue3,
                    analogue4,
                    serial
                ) values (
                    ?, 
                    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
                    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                    1001,
                    1002,
                    1003,
                    1004,
                    'serial text'
                ) 
            ), {}, ($unit_name)
        );
    };

    $self->{dbh} = $dbh;

    bless $self, $class;
    
    return $self;

#    }
#    else {
#        croak "Could not determine state of NET-IOM unit at $unit_name.";
#    }
}

sub update_state {
    my $self = shift;
    
    # $self->_get_set_unit_state();
    
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

    return join '', $self->{dbh}->selectrow_array( 
        q(
            select 
            output01,
            output02,
            output03,
            output04,
            output05,
            output06,
            output07,
            output08,
            output09,
            output10,
            output11,
            output12,
            output13,
            output14,
            output15,
            output16 
            from unit_state where unit = ?
        ), {}, $self->{unit_name}
    );
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

    if ($set_to_state) {
        $set_to_state = 1;
    }
    else {
        $set_to_state = 0;
    }

    $output = sprintf( "%02d", $output );

    my $params = "update unit_state set output$output = ? where unit = ?;";

    $self->{dbh}->do( $params, {}, $set_to_state, $self->get_unit_name() );

    return $self->get_output_bit($output);
}

sub set_input_bit {
    my $self         = shift;
    my $input       = shift;
    my $set_to_state = shift;

    if ($set_to_state) {
        $set_to_state = 1;
    }
    else {
        $set_to_state = 0;
    }

    $input = sprintf( "%02d", $input );

    my $params = "update unit_state set input$input = ? where unit = ?;";

    $self->{dbh}->do( $params, {}, $set_to_state, $self->get_unit_name() );

    return $self->get_input_bit($input);
}


sub get_input_bitmap {
    my $self = shift;

    return join '', $self->{dbh}->selectrow_array( 
        q(
            select 
            input01,
            input02,
            input03,
            input04,
            input05,
            input06,
            input07,
            input08,
            input09,
            input10,
            input11,
            input12,
            input13,
            input14,
            input15,
            input16 
            from unit_state where unit = ?
        ), {}, $self->{unit_name}
    );
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
        return $self->{dbh}->selectrow_array( "select analogue$input_no from unit_state where unit = ?", {} , $self->{unit_name} );
    }
}

sub get_serial {
    my $self = shift;

    return $self->{dbh}->selectrow_array( "select serial from unit_state where unit = ?", {} , $self->{unit_name} );
}

sub set_serial {
    my $self = shift;

    croak "Not implemented.";
}

sub get_unit_name {
    my $self = shift;

    return $self->{unit_name};
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

1;
