#!/usr/bin/perl


#print "Enter string: "; $_=<STDIN>; chomp;
#
#if ( ! /(\W+)/ )
#{
#  print "\nOnly alphanumerics found!\n";
#}
#else
#{
#  print "\n$1 Non alphanumerics found!\n";
#}
#
#

while (<>)
{
  chomp;
  if ( /(\W)/ )
  {
    print "Found non-letters : $1 \n";
  }
  else
  {
    print "Found only letters\n";
  }
  print "\n";
}


