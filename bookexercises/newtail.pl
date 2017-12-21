#!/usr/bin/perl
#

$lineread=0;
$tailfile=$ARGV[0];
$initiallines=$ARGV[1];
$lines=(split(' ', `wc -l $tailfile`))[0];
open(th, "$tailfile");

while ($lineread < ($lines - $initiallines))
{
  <th>;
  $lineread++;
}
    
for (;;)
{
  sleep(0.5);
  while ($lineread < $lines)
  {
    $_=<th>; print $_;
    $lineread++;
  }
  $lines=(split(' ', `wc -l $tailfile`))[0];
}
