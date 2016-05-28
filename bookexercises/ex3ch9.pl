#!/usr/bin/perl
use strict;
use warnings;

my $i;
my $line=0;
open(fh,"$ARGV[0]");
shift @ARGV;
while (<fh>)
{
  $line++;
  for $i (@ARGV)
  {
    if ($i==$line)
    { print "$i : $_"; }
  }
} 
