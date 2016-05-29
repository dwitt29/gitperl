#!/usr/bin/perl

use strict;
use warnings; 
use DBI;

my $database="markets";
my $hostname="192.168.1.3";
my $port=3306;
my $user="dave";
my $password="test123";

my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, $user, $password);
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
	timestamp time,
	lastprice decimal(5,2),
	bid decimal(5,2),
	ask decimal(5,2),
	net decimal(5,2),
	high decimal(5,2),
	low decimal(5,2),
	vol int,
	lotsize int);");

print "Error: $DBI::err ... $DBI::errstr\n" if $DBI::err ;


$dbh->do("insert into test.stocks values(\"IBM\",now(),169.38,169.20,169.76,2.43,169.89,167.52,4225488, 100);");

$sth=$dbh->prepare("select * from test.stocks;");
$sth->execute();
while (my $ref=$sth->fetchrow_hashref())
{
  print "found row:symbol=$ref->{'symbol'},when=$ref->{'timestamp'},last price=$ref->{'lastprice'}\n";
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
