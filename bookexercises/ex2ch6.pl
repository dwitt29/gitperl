#!/usr/bin/perl

use strict;
use warnings;

my $goodpin="01214";
my $tries=3;
my $a="0";
my $attempts=0;

while ( ($a ne $goodpin) && ($attempts < $tries) )
{
  print "Enter a pin ";
  $a=<STDIN>;
  chomp($a);
  $a eq $goodpin ? print "Good pin\n" : print "wrong pin ", "$a " x 5, "\n";
  ++$attempts;
}
