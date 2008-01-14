#!/usr/bin/perl

use strict;
use warnings;

use NETIOM;
use Term::ReadKey;
ReadMode 4; # Turn off controls keys

my @unit;
foreach my $unit ('netiom01', 'netiom02') {
    push @unit, NETIOM->new($unit);
}

system 'clear';

my $unit_index = 0;
while ( 1 ) {

    # my $key;
    while ( defined ( my $key = ReadKey(-1) ) ) {
        if ( $key eq 'q' or $key eq 'Q') {
            exit 0;
        }
        elsif ( $key =~ m/[0-9a-f]/i && $unit[$unit_index]->can('set_input_bit') ) {
            
            if ( ! $key ) {
                $key = 10;
            }
            elsif ( $key =~ m/[a-f]/i ){
                $key = ord(uc($key))-54
            }
            
            $unit[$unit_index]->set_input_bit($key,$unit[$unit_index]->get_input_bit($key) ? 0 : 1);
        }
        elsif ( $key =~ m/u/i ) {
            $unit_index = ($unit_index) ? 0 : 1;
        }
    }
    
    my $out;
    
    foreach my $unit (@unit) {
        $unit->update_state();
        
        if ( $unit eq $unit[$unit_index] && $unit[$unit_index]->can('set_input_bit') ) {
            $out .= $unit[$unit_index]->get_unit_name() . " <-- Active unit for input, press u to toggle.\n";
            $out .= "Press   1  2  3  4  5  6  7  8  9  0  A  B  C  D  E  F\n";
            $out .= "       01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16\n";
        }
        else {
            $out .= $unit->get_unit_name ."\n\n";
            $out .= "       01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16\n";
        }
        $out .= "Input   " . (join "  ", $unit->get_input()) . "\n";
        $out .= "Output  " . (join "  ", $unit->get_output()). "\n\n";
    }
    $out .= "Press q to quit.\n";
    system 'clear';
    print $out;
    sleep 1;
}

END {
    ReadMode 0; # Reset tty mode before exiting
}

