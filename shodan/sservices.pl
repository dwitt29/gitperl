#!/usr/bin/perl


use WWW::Shodan::API;
use Data::Dumper;

use constant APIKEY => 'eSlIvCMYjmCVEBDXdiw20auKT5EGVBvl';

my $shodan = WWW::Shodan::API->new( APIKEY );

print Dumper $shodan->api_info;
#print Dumper $shodan->services;
#print Dumper $shodan->host_ip({ IP => '23.76.228.48' });

my $query = {
    product => 'Apache',
    port    => 80,
 #   link    => 'AX.25 radio modem',
 #   os      => 'windows 7 or 8',
 #   before  => '28/05/2014',
 #   after   => '17/03/2011',
    country => 'US',
};

my $facets = [ { 'isp' => 3 }, { 'os' => 2 }, 'version' ];

$shodan->search( $query, $facets, { PAGE => 5 ,NO_MINIFY => 1 } )

