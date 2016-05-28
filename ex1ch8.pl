#/usr/bin/perl
#

print "\n(a)\n";
my $counter = 0;

@array = (1..10);
for $counter (@array)
{
  print ++$counter, " ";
}
print "\n The whole array:\n@array\n";
print "\$counter: $counter\n";


print "\n(b)\n";
my $counter=0;

@array=(1..10);
for $counter (1..10)
{
  print ++$counter, " ";
}

print "\n The whole array:\n@array\n";
print "\$counter: $counter\n";
