package More;
require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw (print version);
our $VERSION = 1.00;


sub print
{
  my $file = shift;
  print "->> $file <<-\n";
}

sub version
{
  print ">> $VERSION <<\n";
}


1;

