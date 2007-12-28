#!/usr/bin/perl -w -T
package Device::NETIO::Server;

use strict;
use warnings;

use base qw(Net::Server::Fork);

use YAML;
use Data::Dumper;
use Perl6::Say;

$| = 1;

sub process_request {
    my $self = shift;
    
    my $yaml = '';
    
    warn "Got request\n";
    print "SEND\r\n";
    while (<STDIN>) {
        s/\r?\n$//;
        if ( /^\.\.\./ ) {
            last;
            #$self->{server}->{client}->shutdown(0);
        }
        warn "$_\n";
        $yaml .= "$_\n";
    }
    
    # warn "$yaml\n";
    # warn Dumper(Load($yaml)) . "\n";
    warn "Closing\n";
    print "CLOSE\r\n";
    #print "CLOSE\r";
    #$self->{server}->{client}->shutdown(1);
    $self->{server}->{client}->shutdown();
    
}

Device::NETIO::Server->run(port => 81);
