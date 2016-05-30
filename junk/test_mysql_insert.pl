#!/usr/bin/perl -w
use strict;

use DBI;

my $server = 'localhost';
my $db = 'fx';
my $table = 'fx_curr_conv';
my $u = 'root';
my $p = 'test123';

my $dbh=DBI->connect("dbi:mysql:$db:$server", $u, $p);

#my $query = " 
#		select * 
#		from $db.$table
#";

my $sql = " 
	insert into $db.$table  
	(curr_from, curr_from_amt, curr_to, curr_to_amt)	
        values('USD', 10000000.00, 'CAD', 9987500.00)
";

my $retval = $dbh->do($sql);

print "Return value from INSERT: $retval\n";

$dbh->disconnect;

