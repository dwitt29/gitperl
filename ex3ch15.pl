#!/usr/bin/perl


use strict;
use warnings;

my %words;
open(F,"word_input.txt");

while ( <F> )
{
  chomp;
  my (@line) = split (/ /);
  my $word;
  for $word (@line)
  {
    if ( ! defined($words{$word}) )
    {
      $words{$word} = [ 1 , $_];
    }
    else
    {
      $words{$word}[0]++;
      push $words{$word},  $_ ; 
    }
  }
  
}

print "\n";

my $i;
my $k;
for $i (keys %words)
{
  print "$i: $words{$i}[0]\n";
  for ($k=1; $k<@{$words{$i}}; $k++)
  { 
    print "$words{$i}[$k]\n";
  }
  print "\n";
}
