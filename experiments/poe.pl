#!/usr/bin/perl

use warnings;
use strict;

use MYAML;
use YAML;
use Data::Dumper;

use Perl6::Say;

use POE qw(Component::Server::TCP);

use WWW::Mechanize;

my $mech = WWW::Mechanize->new();
my $yaml = '';
my $data;

POE::Component::Server::TCP->new(
    Port => 81,

    ClientConnected => \&client_connected,

    ClientInput => \&client_input_x,

    #ClientInputFilter => [ 'POE::Filter::Reference', 'MYAML' ],
    ClientInputFilter  => "POE::Filter::Line",
    ClientOutputFilter => "POE::Filter::Line",

    # ClientOutputFilter => POE::Filter::Reference->new(MYAML->new()),

    # ClientDisconnected => \&handle_client_disconnect,
);

POE::Kernel->run();
exit;

sub client_connected {
    my ($heap) = $_[HEAP];

    # $kernel->delay_set( 'netiom_sentinel', 1 );

    # warn "Client Connected\n";

    $yaml = '';
    $data = 0;

    $heap->{client}->put("SEND");

    process_client_yaml(
        $mech->get('http://192.168.1.59/client.cgi')->content() );
}

sub client_input {
    my ( $heap, $input ) = @_[ HEAP, ARG0 ];

    warn "client_input\n";

    $heap->{client}->put("CLOSE");

    say Dumper $input;

}

sub client_input_x {

    my ( $heap, $input ) = @_[ HEAP, ARG0 ];

    # say Dumper $input;

    if ( $input =~ /^\.\.\./ ) {

        $heap->{client}->put("CLOSE");

        process_client_yaml($yaml);

    }
    else {
        $yaml .= "$input\n";
    }
}

sub handle_client_disconnect {

    warn "Disconnecting\n";

}

sub process_client_yaml {

    my $yaml = shift;

    $yaml =~ s/\n\.\.\..*/\n/sg;
    $yaml =~ s/\000//sg;

    eval { $data = Load($yaml); };
    if ($@) {
        warn "$@\n";
        warn "$yaml\n";
        return;
    }

    # warn Dumper $data;
    my $n = 1;

    my @input_state  = split //, $data->{digital}{input}{state};
    my @output_state = split //, $data->{digital}{output}{state};

    foreach my $input_state (@input_state) {

        # warn "$n: $input_state vs $output_state[$n-1]\n";

        my $action = 'A';
        if ($input_state) {
            $action = 'B';
        }

        if ( $input_state == $output_state[ $n - 1 ] ) {
            $mech->get(
                "http://192.168.1.59/?$action" . sprintf( '%02d', $n ) . '=1' );
        }
        $n++;
    }
}
