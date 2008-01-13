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
   
my $n=1;
while ( 1 ) {
    system 'clear';   

    if ( my $key = ReadKey(-1) ) {
        if ( $key eq 'q' or $key eq 'Q') {
            quit();
        }
        elsif ( $key =~ m/[1-9]/ ) {
            $unit[0]->set_input_bit($key,$unit[0]->get_input_bit($key) ? 0 : 1);
        }
    }
    
    print "       01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16\n";
    foreach my $unit (@unit) {
        print $unit->get_unit_name ."\n";
        print "Input   " . (join "  ", $unit->get_input()) . "\n";
        print "Output  " . (join "  ", $unit->get_output()). "\n";
    }
    print "Iteration: " . $n++ . "\n";
    sleep 1;
}

sub quit {
    ReadMode 0; # Reset tty mode before exiting
    exit 0;
}

