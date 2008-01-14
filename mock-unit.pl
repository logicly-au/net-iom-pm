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
   
my $n=1;
my $input_range = 'low';
my $unit_index = 0;
while ( 1 ) {

    while ( my $key = ReadKey(-1) ) {
        if ( $key eq 'q' or $key eq 'Q') {
            exit 0;
        }
        elsif ( $input_range eq 'low' && $key =~ m/[1-9]/ && $unit[$unit_index]->can('set_input_bit') ) {
            $unit[$unit_index]->set_input_bit($key,$unit[$unit_index]->get_input_bit($key) ? 0 : 1);
        }
        elsif ( $input_range eq 'high' && $key =~ m/[1-6]/ && $unit[$unit_index]->can('set_input_bit') ) {
            $unit[$unit_index]->set_input_bit($key+10,$unit[$unit_index]->get_input_bit($key+10) ? 0 : 1);
        }
        elsif ( $key =~ m/r/i ) {
            $input_range = ($input_range eq 'high') ? 'low' : 'high';
        }
        elsif ( $key =~ m/u/i ) {
            $unit_index = ($unit_index) ? 0 : 1;
        }
    }
    
    my $out = "       01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16\n";
    foreach my $unit (@unit) {
        $unit->update_state();
        $out .= $unit->get_unit_name ."\n";
        $out .= "Input   " . (join "  ", $unit->get_input()) . "\n";
        $out .= "Output  " . (join "  ", $unit->get_output()). "\n";
    }
    $out .= "Active Unit: " . $unit[$unit_index]->get_unit_name() . "\n";
    $out .= "Input Range: " . (($input_range eq 'high') ? '[10..16]' : '[1..9]' ) . "\n"; 
    $out .= "Iteration: " . $n++ . "\n";
    system 'clear';
    print $out;
    sleep 1;
}

END {
    ReadMode 0; # Reset tty mode before exiting
}

