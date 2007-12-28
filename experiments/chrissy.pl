#!/usr/bin/perl

use WWW::Mechanize;
my $mech = WWW::Mechanize->new();

$mech->get("http://192.168.1.59/?B00=1");

while (1) {

    foreach my $i (1,-1) {

        if ($i == 1) {
            $l=1;
        }
        else {
            $l=8;
        }
    
        for (1 .. 8) {
            
            sleep 1;
    
            $mech->get("http://192.168.1.59/?T0$l=1");
            if ($l >= 2 && $i==1) {
                my $l2 = $l-1;
                $mech->get("http://192.168.1.59/?T0$l2=1");
            }
            elsif ($l <= 7 && $i==-1) {
                my $l2 = $l+1;
                $mech->get("http://192.168.1.59/?T0$l2=1");
            }
            
            $l += $i;
        
        }

    }

}

