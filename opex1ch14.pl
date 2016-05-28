#!/usr/bin/perl

use strict;
use warnings;

my $a = "Do dogs eat cats, or does your cat eat a mouse?";

print "$a\n";
$a =~ s/dog/cat/g;
print "$a\n";
$a =~ s/cat/mouse/g;
print "$a\n";
$a =~ s/mouse/dog/g;
print "$a\n";

my $a = "Do dogs eat cats, or does your cat eat a mouse?";
$a =~ s/cats/mice/g;
print "$a\n";
