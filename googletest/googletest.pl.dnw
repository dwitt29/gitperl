#!/usr/bin/perl
#

open(p,"/etc/passwd");

$uidhash={};

while ( <p> )
{
  ($uname,$pw,$uid,$other)=split(":",$_);
  $uidhash{$uid} .= "$uname:";
}

foreach $i (keys %uidhash)
{
  @temp=split(':',$uidhash{$i});
  if ( @temp > 1 )
  {
    print "\n multiple username with uid=$i --> ";
    for ($t=0;$t<@temp;$t++)
    { print "$temp[$t],"; }
  }
}
print "\n";
