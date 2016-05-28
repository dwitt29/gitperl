#!/usr/bin/perl
#

#open(fh,"data.txt");
my $lines=0;
my $chars=0;
while ( <ARGV> )
{
#  chomp;
  $lines++;
  $chars += length($_);
}


print "\$lines=$lines\n";
print "\$chars=$chars\n";

