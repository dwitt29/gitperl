#!/usr/bin/perl

print "Enter postal code : "; $a=<STDIN>;chomp;


if ( $a =~ m/[A-Z]{1,2}\d{1,2}[A-Z]?\s\d[A-Z]{2}/ )
{
  print "good code\n";
}
else
{ 
  print "bad code\n";
}
