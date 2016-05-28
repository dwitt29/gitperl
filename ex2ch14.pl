#!/usr/bin/perl


use strict;
use warnings;

my $a = "Hello Dudes Is There Any Beer?";


#$a =~ m/((\w+)\s+(\w+))\s+(\w+)/;
$a =~ m/((\w+)(\s+))*\z/;

print "\$1 $1 \n";
print "\$2 $2 \n";
print "\$3 $3 \n";
print "\$4 $4 \n";
print "\$5 $5 \n";
