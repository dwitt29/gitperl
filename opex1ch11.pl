#!/usr/bin/perl

my $owner;
my $name="Untitled";
my $colour="Black";
my $texture="Weave";
my $width=0;
my $backgorund="White";

sub displayvars
{
  for (@_)
  {
    print "$_\n";
  }
}


displayvars("hello",$name,$colour,$width);


