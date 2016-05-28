#!/usr/bin/perl


for (;;)
{

  print "Perl > ";
  <STDIN>;
  eval;
  print $@;

}
