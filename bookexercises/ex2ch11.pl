#!/usr/bin/perl


sub argdisplay
{
    (@sentargs)=@_;

    print "First arg : $sentargs[0]\n";
}

my $a=5;
my $b=6;
my @c=(1,2,3,4);
my %d=qw(dave hockey evan hockey daniela shopping);

argdisplay($a);
argdisplay $b,$a ;
argdisplay(@c);
argdisplay(%d);



