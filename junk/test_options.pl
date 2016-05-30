#!/usr/bin/perl -w

use Finance::QuoteOptions;
use Getopt::Long;

my $symbol;
my $result;
$result = GetOptions ("symbol=s" => \$symbol);    # string

##my $q=Finance::QuoteOptions->new('IBM');

my $q=Finance::QuoteOptions->new($symbol);
die 'Retrieve Failed' unless $q->retrieve;


#Expiration dates in ISO format (YYYYMMDD)
my @expirations = @{$q->expirations};

#Calls/Puts for next expiration, sorted by strike price
my @calls = @{$q->calls(0)};  ## should be an array of hashes
my @puts = @{$q->puts(0)};  ## should be an array of hashes


@values=("symbol","strike","bid","ask","last","open","change","volume","in_the_money");

# header
foreach $k (@values)
{ print "$k,"; }
print "\n";

for $i (@calls)
{
#  for $k (keys %$i)
  foreach $k (@values)
  {
#    print "$k=$i->{$k}\n";
    print "$i->{$k},";
  }
  print "\n";
}


for $i (@puts)
{
#  for $k (keys %$i)
  foreach $k (@values)
  {
#    print "$k=$i->{$k}\n";
    print "$i->{$k},";
  }
  print "\n";
}
  print "\n";
