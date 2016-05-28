#!/usr/bin/perl

use strict;
use warnings;

opendir(D,'.');

my $i;
my %sizehash=();
for $i (readdir(D))
{
  print "$i size is ", (stat($i))[7], "\n";
  $sizehash{$i}=(stat($i))[7];
}

my %temphash=%sizehash;
my $size=keys %temphash;
my $minkey;
my $minsize;

print "Sorting...\n";
while ($size > 0 )
{
  for $i (keys %temphash)
  {
    if (! defined $minsize)
    {
      $minsize=$temphash{$i};
      $minkey=$i;
    }
    elsif ( $temphash{$i} < $minsize )
    {
      $minsize = $temphash{$i};
      $minkey = $i;
    }
  }
  print "$minkey : $minsize\n";
  delete $temphash{$minkey};
  undef $minsize;
  undef $minkey;
  $size=keys %temphash;  
}


  
