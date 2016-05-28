#!/usr/bin/perl


use Carp;
use strict;
use warnings;
use more;
use Net::FTP;

for my $k (keys %INC)
{
  print "key: $k = $INC{$k}\n";
}
