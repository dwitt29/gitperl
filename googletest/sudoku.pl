#!/usr/bin/perl

use strict; use warnings;

my @badsudoku = ( 	

[1,2,3,4,5,6,7,8,9],
[2,3,4,5,6,7,8,9,1],
[3,4,5,6,7,8,9,1,2],
[4,5,6,7,8,9,1,2,3],
[5,6,7,8,9,1,2,3,4],
[6,7,8,9,1,2,3,4,5],
[7,8,9,1,2,3,4,5,6],
[8,9,1,2,3,4,5,6,7],
[9,1,2,3,4,5,6,7,8],

);

my @goodsudoku = (

[2,7,6,3,1,4,9,5,8],
[8,5,4,9,6,2,7,1,3],
[9,1,3,8,7,5,2,6,4],
[4,6,8,1,2,7,3,9,5],
[5,9,7,4,3,8,6,2,1],
[1,3,2,5,9,6,4,8,7],
[3,2,5,7,8,9,1,4,6],
[6,4,1,2,5,3,8,7,9],
[7,8,9,6,4,1,5,3,2],
);

sub checkrows
{
  my (@puzzle) = @_;
  my $row; my $col;
  my %hash=(); my @keycount;

  for $row (0..8)
  {   
    %hash=();@keycount=();
    for $col (0..8)
    { $hash{$puzzle[$row][$col]}=1;  }
    @keycount = keys (%hash);
    if ( (scalar @keycount) < 9 )
    {  return "Bad puzzle, check Row : ", $row+1,"\n"; }
  }    
  return "Good Puzzle based on Rows\n";
}

sub checkcols
{
  my (@puzzle) = @_;
  my $row; my $col;
  my %hash=(); my @keycount;

  for $col (0..8)
  {
    %hash=();@keycount=();
    for $row (0..8)
    { $hash{$puzzle[$row][$col]}=1;  }
    @keycount = keys (%hash);
    if ( (scalar @keycount) < 9 )
    {  return "Bad puzzle, check Column : ", $col+1,"\n"; }
  }
  return "Good Puzzle based on Columns\n";
}

sub check3x3
{
  my (@puzzle) = @_;
  my $row; my $col;
  my %hash=(); my @keycount;
  my $rowoffset=0; my $coloffset=0;
  
  for $rowoffset (0,3,6)
  {
    for $coloffset (0,3,6)
    {
        %hash=();@keycount=();
        for $row (0..2)
        {
          for $col (0..2)
          { $hash{$puzzle[$row+$rowoffset][$col+$coloffset]}=1; }
        }
    @keycount = keys (%hash);
    if ( (scalar @keycount) < 9 )
    {  return "Bad puzzle, check 3x3 box : ", $rowoffset+($coloffset/3)+1,"\n"; }
    }
  }
  return "Good Puzzle based on 3x3 boxes\n";
}

print "\nChecking \@badsudoku\n";
print checkrows(@badsudoku);
print checkcols(@badsudoku);
print check3x3(@badsudoku);

print "\nChecking \@goodsudoku\n";
print checkrows(@goodsudoku);
print checkcols(@goodsudoku);
print check3x3(@goodsudoku);
