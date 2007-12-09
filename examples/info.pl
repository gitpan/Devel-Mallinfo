# Copyright 2007 Kevin Ryde

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


# Print the hash of info returned by Devel::Mallinfo::mallinfo().
#
# In this program it's the first thing done so the values will be near
# the minimum for any perl program.  You can see how many megs your actual
# program and libraries then add!
#
# The printf has a hard-coded 10 chars for the names and 7 for the values,
# but you could find the widest of each at runtime if you wanted.

use Devel::Mallinfo;
my $h = Devel::Mallinfo::mallinfo;
print "mallinfo:\n";
foreach my $field (sort keys %$h) {
  printf "  %-10s  %7d\n", $field, $h->{$field};
}

require Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;
print "\n";
print "or the same with Data::Dumper,\n", Data::Dumper::Dumper ($h);

exit 0;
