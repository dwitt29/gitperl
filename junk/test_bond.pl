#!/usr/bin/perl

use HTML::Parser;
use LWP::UserAgent;
require LWP::UserAgent;
 
 my $ua = LWP::UserAgent->new;
 $ua->timeout(10);
# $ua->proxy(['http'],'http://192.168.1.1');
 $ua->env_proxy;
 
# my $response = $ua->get('http://www.cnbc.com/id/15839203/site/14081545/');
#my $response = $ua->get('http://www.cnbc.com/');
#my $response = $ua->get('http://www.bloomberg.com/markets');
my $response = $ua->get('http://www.bloomberg.com/markets/rates-bonds/government-bonds/us/');
 
 if ($response->is_success) {
     open(htmlfile,">/tmp/dave.html");
     print htmlfile $response->decoded_content;  # or whatever
     close htmlfile;
 }
 else {
     die $response->status_line;
 }

open(htmlfile, "/tmp/dave.html");

exit;

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

print "BOND = $bond\n";
print "COUPON = $coupon\n";
print "MATURITY = $maturity\n";
print "PRICE/YIELD = $price / $yield\n";
#print "$yield\n";
print "PRICE/YIELD CHG = $price_chg / $yield_chg\n";
#print "$yield_chg\n";
print "TIME = $time\n";

