use strict;
use warnings;
use inc::Module::Install;

name            'NETIOM';
all_from        'lib/NETIOM.pm';

install_script  'script/net-iom-mon.pl';

WriteAll;
