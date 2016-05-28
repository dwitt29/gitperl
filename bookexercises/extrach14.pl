#!/usr/bin/perl


use strict;
use warnings;

my $i;
open (F, "commasep.txt");
while ( <F> )
{
  $i++;
  print "line $i\n";
  m/(\w+|\W*),(\w+|\W*),(\w+|\W*),(\w+|\W*),/;

  print "\$1 = $1 \n";
  print "\$2 = $2 \n";
  print "\$3 = $3 \n";
  print "\$4 = $4 \n";
  print "\n";
}


