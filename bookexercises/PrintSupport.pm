package PrintSupport;

sub new
{
  return bless {}
}

sub setup
{
  print "PrintSupport::setup()\n";
}

sub layout
{
  print "PrintSupport::layout()\n";
}

sub display
{
  print "PrintSupport::display()\n";
}

1;
