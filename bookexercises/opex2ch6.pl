#!/usr/bin/perl

use strict;
use warnings;

my $need=6;
my %lotnums=();
my $num=0;
my @nArray=();

while ( scalar keys %lotnums < $need )
{
  $num=int(rand(49))+1;
  ( ! defined $lotnums{$num} ) &&  ($lotnums{$num}=$num );
}


(@nArray) = sort { $a <=> $b } keys %lotnums;
$" = "\n"; print "@nArray";
print "\n";
  
