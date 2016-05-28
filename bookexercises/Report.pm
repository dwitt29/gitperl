package Report;

use PrintSupport;

BEGIN
{
  @ISA = ( 'PrintSupport' ); 
}

sub new
{
  return bless {};
}

sub setup
{
  print "Report::setup()\n";
}

sub display
{
  print "Report::display()\n";
}


1;
