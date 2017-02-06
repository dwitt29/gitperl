#!/usr/bin/perl

use Finance::QuoteHist::Yahoo;
use strict;
use warnings;
use diagnostics;

sub average{
# https://edwards.sdsu.edu/research/calculating-the-average-and-standard-deviation/
        my($data) = @_;
        if (not @$data) {
                die("Empty arrayn");
        }
        my $total = 0;
        foreach (@$data) {
                $total += $_;
        }
        my $average = $total / @$data;
        return $average;
}

sub stdev{
# https://edwards.sdsu.edu/research/calculating-the-average-and-standard-deviation/
        my($data) = @_;
        if(@$data == 1){
                return 0;
        }
        my $average = &average($data);
        my $sqtotal = 0;
        foreach(@$data) {
                $sqtotal += ($average-$_) ** 2;
        }
        my $std = ($sqtotal / (@$data-1)) ** 0.5;
        return $std;
}

my @stocks = [qw(IBM HP)];
my $q = new Finance::QuoteHist::Yahoo
   (
#    symbols    => [qw(IBM HP)],
    symbols    => @stocks,
    start_date => '01/01/2016',
    end_date   => 'today',
   );
 
my %h=();
my %calcs=();
my @ratiosA=();

# Values
foreach my $row ($q->quotes()) {
   my ($symbol, $date, $open, $high, $low, $close, $vol) = @$row;
   print "$symbol, $date, $open, $high, $low, $close, $vol\n";
   $h{$date}{$symbol} = {
	open => $open,
	high => $high,
	low => $low,
	close => $close,
	vol => $vol,
   }
}
      
foreach my $d (sort keys %h) {
  $h{$d}{ratio} = $h{$d}{$stocks[0][0]}{close}/$h{$d}{$stocks[0][1]}{close};
  $h{$d}{zscore}=0;
  $h{$d}{signal}=0;
  push @ratiosA, $h{$d}{ratio} * 1 ;
  print "Ratio $d: $h{$d}{ratio}\n"
}

#$h{avg}=0; $h{stddev}=0;

my $avg=0;
$avg=sprintf "%f",average(\@ratiosA);
my $stddev=0;
$stddev=sprintf "%f",stdev(\@ratiosA);
$h{calc}{avg} = $avg;
$h{calc}{stddev} = $stddev;

printf "AVG %f\n",$avg;
printf "STDDEV %f\n",$stddev;
#printf "AVG %f\n",$h{avg};
#printf "STDDEV %f\n",$h{stddev};

foreach my $d (sort keys %h) {
  if ($d eq "calc" ) { next;}
  $h{$d}{zscore}=($h{$d}{ratio}-$h{calc}{avg})/$h{calc}{stddev};
  print "Zscore $d: $h{$d}{zscore}\n";
}


exit;

# Splits
foreach my $row ($q->splits()) {
  my ($symbol, $date, $post, $pre) = @$row;
}
          
# Dividends
foreach my $row ($q->dividends()) {
  my ($symbol, $date, $dividend) = @$row;
}
