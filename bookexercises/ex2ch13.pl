#!/usr/bin/perl


use strict;
use warnings;

my %oshash = (
	'MVS' => '5.2.1',
	'Windows' => 'NT',
	'OS/2' => 'Merlin',
	'Linux' => '2.2',
	'HP-UX' => '10',
	'Solaris' => '2.5',
	'Mac' => 'Copeland'
);

print "A) Sorted Keys\n";
my @a = sort { $a cmp $b } keys %oshash;
print "@a\n\n";


print "B) Sorted Keys with their values\n";
$"="\n";
print "$_:$oshash{$_}\n" for @a;

print "\nE) values in sorted key order\n";
$"="\n";
print "$oshash{$_}\n" for @a;

print "\nC) Sorted Values\n";
@a = sort { $a cmp $b } values %oshash;
print "@a\n\n";

print "\nD) Keys in order of Sorted Values\n";
my @b = %oshash;
@a = reverse @b;
my %oshash2 = @a;
@a = sort { $a cmp $b } keys %oshash2;
print "$oshash2{$_}\n" for @a;
