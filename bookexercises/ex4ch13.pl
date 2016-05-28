#!/usr/bin/perl


chdir("/var");
my @stuff = `ls -l`;
chomp @stuff;
my @dirs = grep /^d/, @stuff;
$"="\n";

print "@dirs";

print "\n";
