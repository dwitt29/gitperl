#!/usr/bin/perl

use strict;
use warnings;

my $lines=0;
my $bytes=0;
my @savefile;

@savefile = `uncompress -c data.txt.Z`;

for (@savefile)
{
  $lines++;
  $bytes += length($_);
}


print "lines = $lines\n";
print "bytes = $bytes\n";


