#!/usr/bin/perl
open(in,"/tmp/in.txt");
open(out,">/tmp/out.txt");
while ( <in> )
{
  chomp;
  /(\C{5})\C{15}(\C{2})\C{15}(\C{2})\C{2}(\C*)/;
  print out "$1$2$3$4\n";
}
close in;
close out;
