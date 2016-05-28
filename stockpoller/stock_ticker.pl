#!/usr/bin/perl -w

use strict;
use Finance::Quote;

my $CURRENCY="USD";

my @stocks = (
#		[qw/usa RHAT MSFT IBM/]
		[qw/usa GS JPM MSFT IBM rht indexdjx/]
);

my @labels = (
	      ["symbol",  "%12s",  12],
#	      ["name",  "%12s",  12],
#	      ["date",  "%11s",  11], 
	      ["time",  "%10s",  11],
	      ["last",  "%8.2f",  8],
	      ["bid",  "%8.2f",  8],
	      ["ask",  "%8.2f",  8],
	      ["net",  "%9.2f",  9],
	      ["high",  "%8.2f",  8], 
	      ["low",   "%8.2f",  8],
#	      ["close", "%8.2f",  8], 
	      ["volume","%10d",  11]
      );

my $REFRESH = 1;	# Seconds between refresh.

my $quoter = Finance::Quote->new();
my $clear = `clear`;

# Build our header.
#
my $header = "\t\t\t\tSTOCK REPORT" .($CURRENCY ? " ($CURRENCY)" : "") ."\n\n";

foreach my $tuple (@labels) 
{
  my ($name, undef, $width) = @$tuple;
  $header .= sprintf("%".$width."s",uc($name));

}

$header .= "\n".("-"x85)."\n";

$quoter->set_currency($CURRENCY) if $CURRENCY;	# Set default currency.

print $header;
my %pvol;

foreach my $stockset (@stocks)
{
  my (undef, @symbols) = @$stockset;
  foreach my $symbol (@symbols)
  {
    $pvol{$symbol}=0; 
  }
}

for (;;) 
{	
#  print $clear,$header;

  foreach my $stockset (@stocks) 
  {
    my ($exchange, @symbols) = @$stockset;
    my %info = $quoter->fetch($exchange,@symbols);

    foreach my $symbol (@symbols) 
    {
      next unless $info{$symbol,"success"}; # Skip failures.
      foreach my $tuple (@labels) 
      {
        my ($label,$format) = @$tuple;
        printf $format,$info{$symbol,$label};
      }
      printf "%10d",$info{$symbol,"volume"} - $pvol{$symbol};
      $pvol{$symbol}=$info{$symbol,"volume"};
      print "\n";
    }
  }
  sleep($REFRESH);
}

__END__

