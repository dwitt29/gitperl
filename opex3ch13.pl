#!/usr/bin/perl

use strict;
use warnings;

open(F,"readme.txt");

my %words=();
my $total;

while ( <F> )
{
  chomp;
  $words{length($_)}++;
  $total++;
}

print "$_ $words{$_} \t",int(100*$words{$_}/$total),"%\t","X" x $words{$_},"\n" for sort { $a <=> $b } keys %words;
