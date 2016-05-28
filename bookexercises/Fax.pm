package Fax;

use PrintSupport;

BEGIN
{
  @ISA = ('PrintSupport');
}

sub new
{
  return bless {};
}

sub setup
{
  print "Fax: setup()\n";
}

sub display
{
  print "Fax: display()\n";
}

1;

