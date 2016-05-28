#!/usr/bin/perl


my $countfile="count.txt";
my $LOCK_EX=2;
my $LOCK_UN=8;
my $data=0;

-f $countfile ? open(fh, "+< $countfile") : open (fh, " > $countfile");

flock fh, $LOCK_EX;
$|=1;
print "Sleeping..."; sleep(30);  print "Awake.\n";
my $data = <fh> or $data=0;
$data++;
seek fh, 0, 0;
print fh $data;
flock fh, $LOCK_EX;
close fh
