#!/usr/bin/perl
#

use strict;
use warnings;

open(F,"readme.txt");

my @words=();
while ( <F> )
{
  chomp;
  push @words, $_, length($_);
}

#print "$_ " for @words;

my %newwords=reverse @words;

print "$_ $newwords{$_}\n" for sort { $a <=> $b }keys %newwords;



