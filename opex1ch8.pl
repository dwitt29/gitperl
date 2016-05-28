#!/usr/bin/perl

use strict;
use warnings;

my $size;
my $chunklimit;
my $i;
my $stem;
my %results;

open fh,"data.txt";

while ( <fh> )
{
  chomp;
  $size=length($_);

  if ($size >= 6)
  {$chunklimit=6;}
  else
  {$chunklimit=$size;}

  for ($i=2;$i<=$chunklimit;$i++)
  {
      $stem=substr ($_,0,$i);
      $results{$stem}++; 
  }
}

my $k;
my $keysize;
my @stemvalue;
my @stemstring;
foreach $k (keys %results)
{
  $keysize=length($k);

  if ( ( ! defined $stemstring[$keysize] ) || ($stemvalue[$keysize] < $results{$k}) )
  { 
    $stemvalue[$keysize]=$results{$k};
    $stemstring[$keysize]=$k;
  }
}

for $i (2..6)
{
  print "$stemstring[$i] --> $stemvalue[$i]\n";
}

print "\n"; 
