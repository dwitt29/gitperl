#!/usr/bin/perl -w

sub Parse_Cmd_Line
{
  use Getopt::Long;
  my $symbol;
  my $result;
  if ( GetOptions ("symbol=s" => \$symbol) )    # string
  {  return($symbol); }
  else
  {  die "GetOptions() failed"; }
}

sub Collect_Stock_Info
{
  my ($symbol) = $_[0];
  use strict;
  use Finance::Quote;

  my $CURRENCY = "USD";
  my $REFRESH = 2; 
  my $prev_volume;
  my $prev_last;
  my $prev_bid;
  my $prev_ask;

  my @STOCKS = (
              [qw/usa/,$symbol],
             );

  my @labels = (["name",  "%12.15s\t",  15],
              ["date",  "%11s",  11],
              ["time",  "%6s",  7],
              ["last",  "%8.3f",  8],
              ["bid",  "%8.3f",  8],
              ["ask",  "%8.3f",  8],
              ["high",  "%8.2f",  8],
              ["low",   "%8.2f",  8],
              ["close", "%8.2f",  8],
              ["volume","%10d",  10],
              ["vchg","%8d",  8], 
              ["action","%6s",  8]);

  my $header = "\t\t\t\tSTOCK REPORT" .($CURRENCY ? " ($CURRENCY)" : "") ."\n\n";

  my $quoter = Finance::Quote->new();

  $quoter->set_currency($CURRENCY) if $CURRENCY; 
  foreach my $tuple (@labels) 
  {
        my ($name, undef, $width) = @$tuple;
        $header .= sprintf("%".$width."s",uc($name));
  }
  $header .= "\n".("-"x112)."\n";

  print "$header";

  $prev_volume=0;
  for (;;) 
  {      
    foreach my $stockset (@STOCKS) 
    {
      my ($exchange, @symbols) = @$stockset;
      my %info = $quoter->fetch($exchange,@symbols);

      foreach my $symbol (@symbols) 
      {
        next unless $info{$symbol,"success"}; # Skip failures.
        foreach my $tuple (@labels) 
        {
          my ($label,$format) = @$tuple;
##          printf $format,$info{$symbol,$label};

          if  ( ( "$label" eq "vchg") )
          {
            if ( $prev_volume != $info{$symbol,"volume"} && ($prev_volume != 0) )
            {
              printf $format,$info{$symbol,"volume"}-$prev_volume;
              $prev_volume=$info{$symbol,"volume"};
             
              if ( $info{$symbol,"last"} > $prev_last )
              {
                $info{$symbol,"action"}="BUY";
              }
              elsif ($info{$symbol,"last"} < $prev_last )
              {
                $info{$symbol,"action"}="SELL";
              }
              elsif ($info{$symbol,"last"} == $prev_last )
              {
                if ($info{$symbol,"last"} == $prev_bid ) 
                {
                  $info{$symbol,"action"}="SELL";
                } 
                elsif ($info{$symbol,"last"} == $prev_ask ) 
                {
                  $info{$symbol,"action"}="SELL";
                }
              }
            }
            else  ## reach here for 1st line 
            {
              $prev_volume=$info{$symbol,"volume"};
            }
          }
          elsif ( "$label" eq "action" )
          {
            printf $format,$info{$symbol,$label};
            $prev_last=$info{$symbol,"last"};
            $prev_bid=$info{$symbol,"bid"};
            $prev_ask=$info{$symbol,"ask"};
          }
          else
          {
            $info{$symbol,"action"}="";
            printf $format,$info{$symbol,$label};
          }
          
        }
        print "\n";
      }
    }
        sleep($REFRESH);
  }
}

###
### Main
###


my $equity_stock=0; 
$equity_stock=&Parse_Cmd_Line;

&Collect_Stock_Info($equity_stock);

