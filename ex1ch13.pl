#!/usr/bin/perl

my @a = qw (John mark carol Neil bruce Dave anna Julia robert Ted);
my @b = sort { lc $a cmp lc $b } @a;

print sort "@b\n";
