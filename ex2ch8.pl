#!/usr/bin/perl


use strict;
use warnings;

#my $i;

#foreach $i (split(/:/,$ENV{PATH}))
#{
#  -d $i ? print "$i \Udirectory\n" : print "$i \Unot directory\n";
#}



  -d $_ ? print "$_ \Udirectory\n" : print "$_ \Unot directory\n" for (split(/:/,$ENV{PATH}));
