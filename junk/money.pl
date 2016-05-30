#!/usr/bin/perl


##use Finance::Currency::Convert::XE;
##my $obj = Finance::Currency::Convert::XE->new()
##                || die "Failed to create object\n" ;
##
##my @currencies = $obj->currencies;
##
##my $value = $obj->convert(
##                    'source' => 'GBP',
##                    'target' => 'EUR',
##                    'value' => '123.45',
##                    'format' => 'text'
##            )   || die "Could not convert: " . $obj->error . "\n";
##my @currencies = $obj->currencies;
##exit;


use Finance::Currency::Convert::XE;
my $converter =  new Finance::Currency::Convert::XE();

sub usage()
{
  print "Usage is $0 <amount> <code> <to-code>\n";
  exit (8);
}

if (($#ARGV==0) && ($ARGV[0] eq "-l"))
{
  my @info = $converter->currencies;
#  foreach my $symbol (sort keys %$info)
  foreach my $symbol (@info)
  {
#    print "$symbol  $info->{$symbol}->{$name}\n";
    print "$symbol\n";
  }
  exit(0);
}

if ($#ARGV!=3)
{
  usage();
}

#if ($ARGV[0] != /^([-+]?\d*(?:\.\d*)?)(\S+)$/)
#{
#  usage();
#}

#my $amount=$1;
#my $from_code=$2;
#my $to_code=$ARGV[1];

my $amount=$ARGV[0];
my $from_code=$ARGV[1];
my $to_code=$ARGV[2];
my $last_code=$ARGV[3];

if ($amount !~ /\d/)
{
  usage();
}

my $new_amount = $converter->convert(
			'source' => $from_code,
			'target' => $to_code,
			'value'  => $amount,
			'format' => 'number'
		);

if (not defined($new_amount))
{
  print "cound not convert: ". $converter->error . "\n";
  exit(8);
}

my $next_amount = $converter->convert(
			'source' => $to_code,
			'target' => $last_code,
			'value'  => $new_amount,
			'format' => 'number'
		);

if (not defined($new_amount))
{
  print "cound not convert: ". $converter->error . "\n";
  exit(8);
}

my $last_amount = $converter->convert(
			'source' => $last_code,
			'target' => $from_code,
			'value'  => $next_amount,
			'format' => 'number'
		);

if (not defined($last_amount))
{
  print "cound not convert: ". $converter->error . "\n";
  exit(8);
}

my $profit=$last_amount - $amount;
my @currencies = $converter->currencies;

print "$amount $from_code => $new_amount $to_code => $next_amount $last_code => $last_amount $from_code  (PROFIT=$profit)\n";

use DBI;

my $server = 'localhost';
my $db = 'fx';
my $table = 'fx_tri_arb';
my $u = 'root';
my $p = 'test123';

my $dbh=DBI->connect("dbi:mysql:$db:$server", $u, $p);

my $sql = "
        insert into $db.$table (
		amount,
		from_code,	
		new_amount,
		to_code,
		next_amount,
		last_code,
		last_amount,
		closing_code,
		profit
		)
	values (
		$amount,
		\'$from_code\',
		$new_amount,
		\'$to_code\',
		$next_amount,
		\'$last_code\', 
		$last_amount,
		\'$from_code\',
		$profit
		);
";

my $retval = $dbh->do($sql);
print "Return value from INSERT: $retval\n";

$dbh->disconnect;

