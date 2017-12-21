#!/usr/bin/perl
#

use strict;
use warnings;

my %dectoroman = qw (1 I 5 V 10 X 50 L 100 C 500 D 1000 M 4 IV 9 IX 40 XL 90 XC 400 CD 900 CM );

my $dec=0;
my $decstr;
my $decstrlen=0;
my $i=0;
my $digit=0;
my $multiplier=0;
my @romannums=();

sub convert
{
  my ($digit,$multiplier)=@_;
  my $numpos=$digit*10 ** $multiplier;
  
  if ($digit > 5 && $digit < 9 )
  { return (convert($digit-5,$multiplier), convert(5,$multiplier)); }
  elsif (defined $dectoroman{$numpos} )
  { return "$dectoroman{$numpos}"; }
  else
  { return "$dectoroman{10 ** $multiplier}" x $digit };
}

for(;;)
{
  $multiplier=0;
  @romannums=();
  print "\nEnter Decimal (1-4000) : "; $dec=<STDIN>; chomp($dec);
  if ( ($dec < 1) or ($dec > 4000) )
  { print "Out of range!\n"; redo; }

  $decstr=reverse "$dec"; 
  for ($i=0;$i<length($decstr);$i++)
  {
    $digit=substr($decstr,$i,1);
    push @romannums, convert($digit,$multiplier);
    $multiplier++;
  }
   print reverse @romannums;
}

print "\n";



