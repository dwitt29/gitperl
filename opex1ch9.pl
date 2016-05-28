#!/usr/bin/perl


my @a;
my $words;

while (@ARGV)
{
  open(fh,"$ARGV[0]");
  $words=0;
  while (<fh>)
  {
    chomp;
    s/\s+/ /;
    s/^\s+//g;
    (@a)=split(/ /, $_);
    $words += scalar @a;
#    print "$words : @a\n";
  }
  print "$ARGV[0] has $words words\n";
  close fh;
  shift @ARGV;
}

