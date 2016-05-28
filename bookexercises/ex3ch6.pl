#!/usr/bin/perl

$a="";

while ( "$a" ne "quit" )
{
  print "Enter a word ";
  $a=<STDIN>;
  chomp($a);
  print $a x 5, "\n";
}
