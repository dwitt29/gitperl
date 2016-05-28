#!/usr/bin/perl
#

sub new_scalar_ref
{
  my $a = 1;
  return \$a;
}


$one=new_scalar_ref();
$two=new_scalar_ref();
$three=$one;
$four=$two;
$five=$$one;
$six=$$two;


$$one++;
$$one++;
$$two++;
$$three++;
$$four++;
$five++;
$six++;


print "$$one; $$two; $$three; $$four; $five; $six\n";

