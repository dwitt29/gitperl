#!/usr/bin/perl
#

my @d = qw (1998-08-31 2001-12-14 1970-2-12 1969-11-05 1998-04-10 1970-1-1 );
my $i;
my %sortbox=();
use Time::Local;
foreach $i (@d)
{
  my($yr,$mn,$day)=split(/-/,$i);
  my $epoch=timelocal(0,0,0,$day,$mn-1,$yr-1900);
  $sortbox{$epoch}=$i; 
#  print "$epoch\n";
}

print "$sortbox{$_} \n" for sort { $a <=> $b } keys %sortbox;
