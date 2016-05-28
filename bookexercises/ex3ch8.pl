#!/usr/bin/perl

use warnings;
use strict;

my $i="";
my @a;


while ( "$i" ne "quit")
{
  print "Enter a number : "; $i=<STDIN>;
  chomp $i;
  unless ( "$i" eq "quit") { push @a, $i; }
}

$"= " ";
print "@a";

print "\namount : ", scalar @a, "\n";

my $sum;
$sum += $_ for @a;
print "\nSum : ", $sum;

printf "\nAverage : %0.2f ", $sum/(scalar @a);

my @sorted = sort {$a <=> $b} @a;
print "\nSmallest : ", $sorted[0];
print "\nLargest : ", $sorted[$#sorted];

print "\n";


