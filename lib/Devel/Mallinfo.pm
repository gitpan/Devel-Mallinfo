# Copyright 2007, 2008 Kevin Ryde

# This file is part of Devel::Mallinfo.

# Devel::Mallinfo is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.

# Devel::Mallinfo is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.

# You should have received a copy of the GNU General Public License along
# with Devel::Mallinfo.  If not, see <http://www.gnu.org/licenses/>.


package Devel::Mallinfo;
use strict;
use warnings;
use Exporter;

# Version 1 - the first version
# Version 2 - notice missing malloc.h in the build
# Version 3 - debian dir fixes, attempt config.pl fixes for msdos
#
our $VERSION = 3;

our @ISA = qw(DynaLoader Exporter);
require DynaLoader;
bootstrap Devel::Mallinfo $VERSION;

our @EXPORT = ();
our @EXPORT_OK = ('mallinfo');
our %EXPORT_TAGS = (all => \@EXPORT_OK);

1;
__END__



=head1 NAME

Devel::Mallinfo -- mallinfo() memory statistics

=head1 SYNOPSIS

 use Devel::Mallinfo;
 my $hashref = Devel::Mallinfo::mallinfo();
 print "uordblks used space ", $hashref->{'uordblks'}, "\n";

 # or import into your namespace per Exporter
 use Devel::Mallinfo ('mallinfo');
 my $hashref = mallinfo();

=head1 DESCRIPTION

C<Devel::Mallinfo> is an interface to the C library C<mallinfo> function
giving various totals for memory used by C<malloc>.  This is meant for
development, to give you an idea what your program and libraries are using
or not.

It should be noted C<malloc> isn't the only way memory can be used.  Program
and library data and bss segments and the occasional direct C<mmap> don't
show up in C<mallinfo>.  But normally almost all runtime space goes through
C<malloc>, so it's close to the total, and dynamic runtime usage is often
what you're interested in anyway.

=head1 FUNCTIONS

=over 4

=item C<Devel::Mallinfo::mallinfo()>

Return a reference to a hash of the C<struct mallinfo> values obtained from
C<mallinfo>.  The keys are field name strings, and the values are integers.
For example,

    { 'arena'    => 1234,
      'uordblks' => 5678,
      ...
    }

So for instance to print all the fields (in no particular order),

    my $info = Devel::Mallinfo::mallinfo();
    foreach my $field (keys %$info) {
      print "$field is $info->{$field}\n";
    }

See the C<mallinfo> man page, or the GNU C Library Reference Manual section
"Statistics for Memory Allocation with `malloc'", for what the fields mean.

All the fields in C<struct mallinfo> on your system should be available
since they're grepped out of F<malloc.h> by C<Devel::Mallinfo> at build
time.  Some systems don't have a C<mallinfo> at all, or only have it in a
particular C<malloc> library; if C<mallinfo> isn't available in the
C<malloc> Perl is using then C<Devel::Mallinfo::mallinfo> returns a
reference to an empty hash.

=back

=head1 OTHER NOTES

On a 64-bit system with a 32-bit C C<"int">, the C<int> fields used in
C<struct mallinfo> might overflow (and wrap around to small or negative
values).  This is a known C library problem, which C<Devel::Mallinfo>
doesn't try to do anything about.

=head1 HOME PAGE

L<http://www.geocities.com/user42_kevin/devel-mallinfo/index.html>

=head1 LICENSE

Devel::Mallinfo is Copyright 2007 Kevin Ryde

Devel::Mallinfo is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

Devel::Mallinfo is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
Devel::Mallinfo.  If not, see L<http://www.gnu.org/licenses/>.

=head1 SEE ALSO

C<mallinfo(3)>

=cut
