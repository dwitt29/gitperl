#!/usr/bin/perl


use strict;
use warnings;
#use diagnostics;

sub report_error
{
  my ($p,$f,$l)= caller;
  print scalar(localtime), " Error: @_ (file:$f sub:$p line:$l)\n";
}


my $filename="dave.test.txt";

open (OOPS, $filename) || report_error ("failed to open $filename : ($!)");
close OOPS;


