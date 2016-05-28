
package PrintSupport;
require Exporter;

our @ISA = qw (Exporter);
our @EXPORT = qw ( print_HP print_Xerox print_Apple);
our @EXPORT_OK = qw ( print_fax );
our $VERSION = 1.0;

sub print_HP
{
  my $info=(caller(0))[3];
  print $info,"::Line::",__LINE__,"\n";
}

sub print_Xerox
{
  my $info=(caller(0))[3];
  print $info,"::Line::",__LINE__,"\n";
}

sub print_Apple
{
  my $info=(caller(0))[3];
  print $info,"::Line::",__LINE__,"\n";
}

sub print_fax
{
  my $info=(caller(0))[3];
  print $info,"::Line::",__LINE__,"\n";
}

1;
