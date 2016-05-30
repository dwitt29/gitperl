#!/usr/bin/perl -w
use strict;

use DBI;

my $server = 'localhost';
my $db = 'fx';
my $table = 'fx_curr_conv';
my $u = 'root';
my $p = 'test123';

my $dbh=DBI->connect("dbi:mysql:$db:$server", $u, $p);

my $query = " 
		select * 
		from $db.$table
";

my $sth = $dbh->prepare($query);
$sth->execute();

while (my $row = $sth->fetchrow_arrayref)
{
  print join("\t",@$row),"\n";
}

$dbh->disconnect;

