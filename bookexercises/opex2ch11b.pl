#!/usr/bin/perl
#

use strict;
use warnings;

my %dectoroman = qw (1 I 5 V 10 X 50 L 100 C 500 D 1000 M 4 IV 9 IX 40 XL 90 XC 400 CD 900 CM );
my %romantodec = reverse %dectoroman;
my $dec=0;

sub dec2roman
{
  my @increments = reverse sort { $a <=> $b } keys %dectoroman;
  my ($d) = @_;
  my $roman="";
  my $i;

  while ($d > 0)
  {
    $i = shift @increments;
    while ($d >= $i )
    {
      $roman .= $dectoroman{$i};
      $d -= $i;
    } 
  }
  return $roman; 
}

sub roman2dec
{
  my ($r) = @_; 
  my $dec2add=0;

  while (length($r) > 0)
  {
    if ((length($r) > 1) && (defined ($romantodec{substr($r,0,2)})))
    { $dec2add += $romantodec{ substr($r,0,2)}; $r=substr($r,2); }
    else
    { $dec2add += $romantodec{ substr($r,0,1)}; $r=substr($r,1); }
  }

  return $dec2add;
}

for(;;)
{
  print "\nEnter Decimal (1-4000) : "; $dec=<STDIN>; chomp($dec);
  if ( ($dec < 1) or ($dec > 4000) )
  { print "Out of range!\n"; redo; }
  my $a;
  print $a=dec2roman($dec)," --> ", roman2dec($a);
}

print "\n";



