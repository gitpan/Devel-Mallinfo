# Copyright 2007, 2008, 2009 Kevin Ryde

# This file is part of Devel-Mallinfo.
#
# Devel-Mallinfo is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 3, or (at your option) any later
# version.
#
# Devel-Mallinfo is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with Devel-Mallinfo.  If not, see <http://www.gnu.org/licenses/>.

package Devel::Mallinfo;
use strict;
use warnings;
use Exporter;
use vars qw($VERSION @ISA @EXPORT_OK %EXPORT_TAGS);

$VERSION = 4;

@ISA = qw(DynaLoader Exporter);
@EXPORT_OK = ('mallinfo');
%EXPORT_TAGS = (all => \@EXPORT_OK);

require DynaLoader;
bootstrap Devel::Mallinfo $VERSION;

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
development to give you an idea what your program and libraries is using.

Note C<malloc> isn't the only way memory can be used.  Program and library
data and bss segments and the occasional direct C<mmap> don't show up in
C<mallinfo>.  Normally however almost all runtime space goes through
C<malloc>, so it's close to the total, and dynamic runtime usage is often
what you're interested in anyway.

=head1 FUNCTIONS

=over 4

=item C<$hashref = Devel::Mallinfo::mallinfo()>

Return a reference to a hash of the C<struct mallinfo> values obtained from
C<mallinfo>.  The keys are field name strings, and the values are integers.
For example,

    { 'arena'    => 1234,
      'uordblks' => 5678,
      ...
    }

So to print (in no particular order),

    my $info = Devel::Mallinfo::mallinfo();
    foreach my $field (keys %$info) {
      print "$field is $info->{$field}\n";
    }

Field names are grepped out of C<struct mallinfo> at build time, so
everything on your system should be available.  If C<mallinfo> is not
available in the particular C<malloc> library Perl is using then
C<Devel::Mallinfo::mallinfo> returns a reference to an empty hash.

=back

=head2 Fields

See the C<mallinfo> man page, or the GNU C Library Reference Manual section
"Statistics for Memory Allocation with `malloc'", for what the fields mean.

For reference, on a modern system C<arena> plus C<hblkhd> is the total
memory taken from the system.  C<hblkhd> space is big blocks in use by the
program.  Within the C<arena> space C<uordblks> plus C<usmblks> is currently
in use, and C<fordblks> plus C<fsmblks> is free.

C<hblkhd> space is returned to the system when freed.  C<arena> space may be
reduced by shrinking when there's enough free blocks at its end to be worth
doing.  C<keepcost> is the current free space at the end which could be
given back.

=head1 OTHER NOTES

On a 64-bit system with a 32-bit C C<int> type, the C<int> fields in
C<struct mallinfo> might overflow (and wrap around to small or negative
values).  This is a known C library problem, which C<Devel::Mallinfo>
doesn't try to do anything about.

The C<mallopt> function would be a logical companion to C<mallinfo>, but
generally it must be called before the first ever C<malloc>, so anything in
Perl is much too late.

=head1 HOME PAGE

http://user42.tuxfamily.org/devel-mallinfo/index.html

=head1 LICENSE

Devel-Mallinfo is Copyright 2007, 2008, 2009 Kevin Ryde

Devel-Mallinfo is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

Devel-Mallinfo is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
more details.

You should have received a copy of the GNU General Public License along with
Devel-Mallinfo.  If not, see http://www.gnu.org/licenses/.

=head1 SEE ALSO

C<mallinfo(3)>

=cut
