#!/usr/bin/perl

use strict;
use warnings; 
use DBI;
use Finance::Quote;

my $CURRENCY="USD";

my @stocks = (
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
	      ["close", "%8.2f",  8], 
	      ["volume","%10d",  11]
);

my $REFRESH = 10;	# Seconds between refresh.
my $quoter = Finance::Quote->new();
my $clear = `clear`;
my $header = "\t\t\t\tSTOCK REPORT" .($CURRENCY ? " ($CURRENCY)" : "") ."\n\n";

## print header with upper case column labels
foreach my $tuple (@labels) 
{
  my ($name, undef, $width) = @$tuple;
  $header .= sprintf("%".$width."s",uc($name));
}

$header .= "\n".("-"x85)."\n";	## dotted line
print $header;

$quoter->set_currency($CURRENCY) if $CURRENCY;  # Set default currency.
my %pvol;

## set to zero the previous volume field for all symbols
foreach my $stockset (@stocks)
{
  my (undef, @symbols) = @$stockset;
  foreach my $symbol (@symbols)
  {
    $pvol{$symbol}=0;
  }
}

my $database="markets";
my $hostname="192.168.2.2";
my $port=3306;
my $user="dave";
my $password="test123";
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, $user, $password);

for (;;)
{
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

      ## calc & print volume deltas
      printf "%10d",$info{$symbol,"volume"} - $pvol{$symbol};
      $info{$symbol,"lotsize"}=$info{$symbol,"volume"} - $pvol{$symbol};
      $pvol{$symbol}=$info{$symbol,"volume"};
      print "\n";

      my $sth=$dbh->prepare("insert into test.stocks ( symbol, timestamp, lastprice, bid, ask, net, high, low, vol, lotsize, dtstamp ) values(?, now(), ?, ?, ?, ?, ?, ?, ?, ?, now() );");

      $sth->execute( $info{$symbol,"symbol"}, $info{$symbol,"last"}, $info{$symbol,"bid"}, $info{$symbol,"ask"}, $info{$symbol,"net"}, $info{$symbol,"high"}, $info{$symbol,"low"}, $info{$symbol,"volume"}, $info{$symbol,"lotsize"} );

    }

  }
  sleep($REFRESH);
}

#$drh = DBI->install_driver("mysql");
#@databases = DBI->data_sources("mysql");

#or

#@databases = DBI->data_sources("mysql", {"host" => $host, "port" => $port, "user" => $user, password => $pass});

#$sth = $dbh->prepare("SELECT * FROM foo WHERE bla");
#or
#$sth = $dbh->prepare("LISTFIELDS $table");
#or
#$sth = $dbh->prepare("LISTINDEX $table $index");

my $sth = $dbh->prepare("show databases;");
$sth->execute;

my $numRows = $sth->rows;
my $numFields = $sth->{'NUM_OF_FIELDS'};
while (my $ref=$sth->fetchrow_hashref())
{
  print "found row: name= $ref->{'Database'}\n";
}

$sth->finish;

$dbh->do("create table test.stocks (symbol varchar(5),
	lastprice decimal(5,2),
	bid decimal(5,2),
	ask decimal(5,2),
	net decimal(5,2),
	high decimal(5,2),
	low decimal(5,2),
	vol int,
	lotsize int);");

print "Error: $DBI::err ... $DBI::errstr\n" if $DBI::err ;


$dbh->do("insert into test.stocks values(\"IBM\",169.38,169.20,169.76,2.43,169.89,167.52,4225488, 100);");

$sth=$dbh->prepare("select * from test.stocks;");
$sth->execute();
while (my $ref=$sth->fetchrow_hashref())
{
  print "found row:symbol=$ref->{'symbol'},last price=$ref->{'lastprice'}\n";
}

$sth->finish();
$dbh->disconnect();




#$rc = $drh->func('createdb', $database, $host, $user, $password, 'admin');
#$rc = $drh->func('dropdb', $database, $host, $user, $password, 'admin');
#$rc = $drh->func('shutdown', $host, $user, $password, 'admin');
#$rc = $drh->func('reload', $host, $user, $password, 'admin');

#$rc = $dbh->func('createdb', $database, 'admin');
#$rc = $dbh->func('dropdb', $database, 'admin');
#$rc = $dbh->func('shutdown', 'admin');
#$rc = $dbh->func('reload', 'admin')
