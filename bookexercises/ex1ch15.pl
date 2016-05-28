#!/usr/bin/perl

use strict;
use warnings;


my @f = `ls`;
my $i;
my @info;

for $i (@f)
{
  chomp($i);
  my (@filestats) = stat $i;
  push @info, [$i,$filestats[2],$filestats[7],$filestats[9]];
}

for $i (@info)
{
  print "name=@$i[0] "; printf "mode=%lo ",@$i[1] & 07777; print "size=@$i[2] ", "mod=",scalar localtime(@$i[3]);
  print "\n";
}
 
