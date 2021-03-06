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

  my $response = $ua->get('http://www.bloomberg.com/markets/rates-bonds/government-bonds/us/');
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

sub Display_Bond_Data()
{
  my ($p1, $choice)= @_;
  my %bonds = %$p1;
  my $i=0;
  my $k=0;

  foreach $i (keys %bonds)
  {
    if ("$i" != "$$choice")
    {
      print "$i\n";
      foreach $k ( keys %{$bonds{"$i"}} )
      {
        print "\t$k --> ",$bonds{"$i"}{"$k"},"\n";
      }
    }
  }
}

sub Get_Options()
{
  use Finance::QuoteOptions;

  my $q=Finance::QuoteOptions->new('IBM');

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
#    for $k (keys %$i)
    foreach $k (@values)
    {
#      print "$k=$i->{$k}\n";
      print "$i->{$k},";
    }
    print "\n";
  }

  for $i (@puts)
  {
#    for $k (keys %$i)
    foreach $k (@values)
    {
#      print "$k=$i->{$k}\n";
      print "$i->{$k},";
    }
    print "\n";
  }
  print "\n";
}

sub main()
{
  my %x=();
  my $choice="12-Month";
  %x=&Web_Collect();
  &Display_Bond_Data(\%x, \$choice);
#  &Get_Options();
}

&main()
