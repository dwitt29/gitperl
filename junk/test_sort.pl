#!/usr/bin/perl
open (f, "/tmp/dave1.dat");
while ( <f> )
{
  chomp; $hash{$_}=$_;
  print "orig order: $_\n";
}
close f;

@sorted = sort { $a <=> $b } (keys %hash);

print "\n";

for ($i=0; $i<@sorted; $i++)
{ print "sorted: $hash{$sorted[$i]}\n"; }
