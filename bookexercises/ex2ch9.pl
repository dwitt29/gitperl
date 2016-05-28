#!/usr/bin/perl

$/="\n\n";

while (<ARGV>)
{
  chomp;
  print ">>>$_<<<\n";
}


