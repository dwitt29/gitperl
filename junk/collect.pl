#!/usr/bin/perl -w
use strict;

sub Get_Bonds()
{
  use HTML::Parser;
  use LWP::UserAgent;
  require LWP::UserAgent;

  my $ua = LWP::UserAgent->new;
  $ua->timeout(10);
  $ua->env_proxy;

  my $response = $ua->get('http://www.bloomberg.com/markets');

  if ($response->is_success) {
     open(htmlfile,">/tmp/dave.html");
     print htmlfile $response->decoded_content;  # or whatever
     close htmlfile;
  }
  else {
     die $response->status_line;
  }

  open(htmlfile, "/tmp/dave.html");
  while ( <htmlfile> )
  {
    if (m/US 10-Year/ )
    {
     chomp;
     $bond=$_;
     $coupon=<htmlfile>;
     chomp($coupon);
     $maturity=<htmlfile>;
     chomp($maturity);
     $price=<htmlfile>;
     chomp($price);
     <htmlfile>;
     $yield=<htmlfile>;
     chomp($yield);
     <htmlfile>;
     $price_chg=<htmlfile>;
     chomp($price_chg);
     <htmlfile>;
     $yield_chg=<htmlfile>;
     chomp($yield_chg);
     <htmlfile>;
     $time=<htmlfile>;
     chomp($time);
    }
  }

  $bond=&left_chop($bond);
  $bond=&right_chop($bond);

  $coupon=&left_chop($coupon);
  $coupon=&right_chop($coupon);

  $maturity=&left_chop($maturity);
  $maturity=&right_chop($maturity);

  $price=&left_chop($price);
  $price=&right_chop($price);

  $yield=&left_chop($yield);
  $yield=&right_chop($yield);

  $price_chg=&left_chop($price_chg);
  $price_chg=&right_chop($price_chg);

  $yield_chg=&left_chop($yield_chg);
  $yield_chg=&right_chop($yield_chg);

  $time=&left_chop($time);
  $time=&right_chop($time);

  return($yield);
}

sub left_chop()
{
  ($x)=@_;

  $x=~s/ +//g;
  $x=~s/\s+//g;

  my $strlength=length $x;
  my $first_delim=index($x,">");
  my $sec_delim=rindex($x,"<");

  if ( $sec_delim > $first_delim)
  { $new_string=substr($x,$first_delim+1, $strlength-$first_delim); }
  elsif ( ($strlength-1) == $first_delim )
  { $new_string=$x; }
  elsif ( $sec_delim < $first_delim)
  { $new_string=substr($x,$first_delim+1, $strlength-$first_delim); }

  return $new_string;
}

sub right_chop()
{
  ($x)=@_;

  $x=~s/ +//g;
  $x=~s/\s+//g;

  my $strlength=length $x;
  my $first_delim=index($x,"<");
  my $sec_delim=rindex($x,">");

  if ( $sec_delim > $first_delim)
  { $new_string=substr($x,0,$first_delim); }
  else
  { $new_string=$x; }

  return $new_string;
}



sub Get_Quotes()
{
  use Finance::Quote;

  #my $CURRENCY = "AUD";  # Set preferred currency here, or empty string for
  my $CURRENCY = "USD";   # Set preferred currency here, or empty string for
                        # no conversion.

  my $last_price=0;
  my $stock_symbol=0;

  my @STOCKS = (
##            [qw/asx WGR/],
##            [qw/usa MSFT GOOG LNUX/],
##            [qw/usa IBM RHT DELL/],
##              [qw/usa AAPL IBM GOOG GS RHT CSCO DELL PFE/],
              [qw/usa IBM/],
             );

##my @labels = (["name",  "%12.15s\t",  15],
##              ["date",  "%11s",  11],
##              ["time",  "%10s",  11],
##              ["last",  "%8.2f",  8],
##              ["high",  "%8.2f",  8],
##              ["low",   "%8.2f",  8],
##              ["close", "%8.2f",  8],
##              ["volume","%10d",  10]);

  my @labels = (["symbol",  "%8s",  8],
                ["date",  "%13s",  13],
                ["time",  "%13s",  13],
                ["last",  "%8.2f",  8]);

  #my $REFRESH = 120;     # Seconds between refresh.
  my $REFRESH = 10;       # Seconds between refresh.

  my $quoter = Finance::Quote->new();
  my $clear  = `clear`;                   # So we can clear the screen.

  # Build our header.

  my $header = "\t\t\t\tSTOCK REPORT" .($CURRENCY ? " ($CURRENCY)" : "") ."\n\n";

  foreach my $tuple (@labels) {
          my ($name, undef, $width) = @$tuple;
          $header .= sprintf("%".$width."s",uc($name));
  }

  $header .= "\n".("-"x79)."\n";

  # Header is all built.  Looks beautiful.

  $quoter->set_currency($CURRENCY) if $CURRENCY;  # Set default currency.

  #print "$clear,$header";
#  print "$header";

  ##  for (;;) {      # For ever.
  ##      print $clear,$header;

  foreach my $stockset (@STOCKS) 
  {
    my ($exchange, @symbols) = @$stockset;
    my %info = $quoter->fetch($exchange,@symbols);
    foreach my $symbol (@symbols) 
    {
      $last_price=$info{$symbol,"last"};
      $stock_symbol=$info{$symbol,"symbol"};

      next unless $info{$symbol,"success"}; # Skip failures.
      foreach my $tuple (@labels) 
      {
        my ($label,$format) = @$tuple;
#        printf $format,$info{$symbol,$label};
      }
#      print "\n";
    }
  }

  &Get_Bonds();
  &Get_Options($stock_symbol,$last_price,$yield);

##        sleep($REFRESH);
}

## OPTIONS CODE
sub Get_Options()
{
  use Finance::QuoteOptions;
  my ($stock_symbol,$last_price,$bond_yield)=@_;
  my $q=Finance::QuoteOptions->new($stock_symbol);
  die 'Retrieve Failed' unless $q->retrieve;


  #Expiration dates in ISO format (YYYYMMDD)
  my @expirations = @{$q->expirations};

  #Calls/Puts for next expiration, sorted by strike price
  my @calls = @{$q->calls(0)};  ## should be an array of hashes
  my @puts = @{$q->puts(0)};  ## should be an array of hashes


  my @values=("symbol","strike","bid","ask","last","open","change","volume","in_the_money");

  # header
  my $k;
  foreach $k (@values)
  { print "$k,"; }
  print "equity symbol,last price,bond yield\n";

  my $i;
  for $i (@calls)
  {
  #  for $k (keys %$i)
    foreach $k (@values)
    {
  #    print "$k=$i->{$k}\n";
      print "$i->{$k},";
    }
    print "$stock_symbol,$last_price,$bond_yield\n";
  }


  for $i (@puts)
  {
  #  for $k (keys %$i)
    foreach $k (@values)
    {
  #    print "$k=$i->{$k}\n";
      print "$i->{$k},";
    }
    print "$stock_symbol,$last_price,$bond_yield\n";
#    print "\n";
  }
  print "\n";
}

###
### Main
###

&Get_Quotes();
