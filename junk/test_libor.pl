#!/usr/bin/perl

sub Web_Collect()
{
  use HTML::Parser;
  use LWP::UserAgent;
  require LWP::UserAgent;
  use HTML::TableExtract;

  my $html_string;
  my $ua = LWP::UserAgent->new;
  $ua->timeout(10);
  $ua->env_proxy;

##  my $response = $ua->get('http://www.bloomberg.com/markets/rates-bonds/government-bonds/us/');
  my $response = $ua->get('http://www.wsjprimerate.us/libor/');

  if ($response->is_success) 
  { $html_string = $response->decoded_content; }  # or whatever
  else 
  { die $response->status_line; }

#  my $te = new HTML::TableExtract( count => 0, headers => [qw(COUPON MATURITY PRICE/YIELD PRICE/YIELD CHANGE TIME)] );
  my $te = new HTML::TableExtract( count => 0, headers => [qw(MATURITY RATE)] );
  $te->parse($html_string);

  # Examine all matching tables
##  my %bonds=();
  my %libor=();
  foreach $ts ($te->tables) 
  {
#    print "Table (", join(',', $ts->coords), "):\n";
    foreach $row ($ts->rows) 
    {
       my $maturity="";
       my $rate="";
       $_ = join(',', @$row);
       s/\s+//g;
##        m/Month LIBOR,/gmsox && print "$_\n";		## prints whole retrieved string
       if ( m/Month LIBOR,/gmsox ) 		## prints whole retrieved string
       {
##          print join(',', @$row), "\n";
##         ($name,$coupon,$maturity,$price_yield,$price_yield_chg,$time_stamp)=split(/,/,$temp);
##         ($price,$yield)=split(/\//,$price_yield);
##         ($price_chg,$yield_chg)=split(/\//,$price_yield_chg);

         ($maturity,$rate)=split(/,/,$_);
         if ($maturity && $rate)
         {
           my $rec={};
           $rec->{maturity} = $maturity;
           $rec->{rate} = $rate;
##           $rec->{time_stamp} = $time_stamp;
##           $rec->{yield_chg} = $yield_chg;
##           $rec->{price_chg} = $price_chg;
##           $rec->{yield} = $yield;
##           $rec->{price} = $price;
##           $rec->{maturity} = $maturity;
##           $rec->{coupon} = $coupon;
##           $bonds{$name}=$rec;
           $libor{$maturity}=$rec;
         }
       }
    }
  }
##  return %bonds;
  return %libor;
}

sub Display_Libor_Data()
{
  my ($p1, $choice)= @_;
  my %libor = %$p1;
  my $i=0;
  my $k=0;
 
  print "$$choice rate --> ",$libor{"$$choice"}{"rate"},"\n";

##  foreach $i (keys %libor)
##  {
##    if ("$i" == "$$choice")
##    {
##      print "$i\n";
##      foreach $k ( keys %{$libor{"$i"}} )
##      {
##        print "\t$k --> ",$libor{"$i"}{"$k"},"\n";
##      }
##    }
##  }

  return($libor{"$$choice"}{"rate"}/100);

}

sub Get_Options()
{
  my($label,$rate,$stock_price)=@_;

  use Time::Local;
  use Finance::QuoteOptions;

  my $q=Finance::QuoteOptions->new('IBM');

  die 'Retrieve Failed' unless $q->retrieve;

  foreach $i (keys %{$q})
  { print "$i=$q{$i}\n"; }

  #Expiration dates in ISO format (YYYYMMDD)
  @expirations = @{$q->expirations};
#  @expirations = $q->expirations;
  for ($i=0; $i<@expirations; $i++)
  { print "expirations --> $i = $expirations[$i]\n"; }

  print "expirations --> $expirations[0]\n"; 
  my $year = substr($expirations[0],2,2);
  my $month = substr($expirations[0],4,2);
  my $day = substr($expirations[0],6,2);

  my $one_day=86400;
  my $now = time();
  my $expire_date=timelocal(0,0,16,$day,$month-1,$year);
##  my $tte = int( (timelocal(0,0,16,$day,$month,$year) - time())/$one_day); 
  my $tte = int(  (($expire_date - $now)/$one_day)+0.5); 
  my $T=$tte/360;

  #Calls/Puts for next expiration, sorted by strike price
  my @calls = @{$q->calls(0)};  ## should be an array of hashes
  my @puts = @{$q->puts(0)};  ## should be an array of hashes
##  my @calls = @{$q->calls(201009)};  ## should be an array of hashes
##  my @puts = @{$q->puts(201009)};  ## should be an array of hashes

  @values=("symbol","strike","bid","ask","last","open","change","volume","in_the_money");

  # header
  print "time to expire,T,stock price,";
  foreach $k (@values)
  { print "$k,"; }
  print "$$label\n";

  # security values
  my %put_options=();
  for $i (@puts)
  {
    my $temp;
#    for $k (keys %$i)
    foreach $k (@values)
    {
#      print "$k=$i->{$k}\n";
      $temp .= "$i->{$k},"; 
#      print "$i->{$k},";
    }
#    print "$$rate\n";
    $temp .= "$$rate,"; 
    $put_options{$i->{"symbol"}}=$temp;
  }

  # security values
  for $i (@calls)
  {
    print "$tte,$T,$$stock_price,";
#    for $k (keys %$i)
    foreach $k (@values)
    {
#      print "$k=$i->{$k}\n";
      print "$i->{$k},";
    }
    $call_pos=rindex($i->{"symbol"},"C"); 
    $put_key=substr($i->{"symbol"},0,$call_pos)."P".substr($i->{"symbol"},$call_pos+1);
    print "$$rate,$put_options{\"$put_key\"}\n";
#    print "\n";
  }

  print "\n";
}

sub Get_Stock_Price()
{
  use strict;
  use Finance::Quote;

  my $stock_price=0;
  my $CURRENCY = "USD"; 

  my @STOCKS = (
              [qw/usa IBM/],
             );

  my $quoter = Finance::Quote->new();
 
  foreach my $stockset (@STOCKS) 
  {
    my ($exchange, @symbols) = @$stockset;
    my %info = $quoter->fetch($exchange,@symbols);

    foreach my $symbol (@symbols) 
    {
      my $label="last";
      next unless $info{$symbol,"success"}; # Skip failures.
#      print "$symbol = $info{$symbol,$label}\n";
      $stock_price=$info{$symbol,$label};
    }
  }
  return($stock_price);
}

sub main()
{
  my %x=();
  my $choice="One-MonthLIBOR";
  %x=&Web_Collect();
  my $libor_rate=&Display_Libor_Data(\%x, \$choice);
#  my $stock_price = &Get_Stock_Price();
#  &Get_Options(\$choice,\$libor_rate, \$stock_price);
}

&main()
