#!/usr/bin/perl

# Copyright 2007, 2008, 2009, 2010 Kevin Ryde

# This file is part of Devel-Mallinfo.

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

use strict;
use warnings;
use Devel::Mallinfo ':all';
use Test::More tests => 6;

SKIP: { eval 'use Test::NoWarnings; 1'
          or skip 'Test::NoWarnings not available', 1; }

ok (defined &mallinfo, 'mallinfo() imported');

foreach my $name ('malloc_stats',
                  'malloc_info',
                  'malloc_info_string',
                  'malloc_trim') {
  my $fullname = "Devel::Mallinfo::$name";
  if (exists &$fullname) {
    ok (exists &$name, "$name() imported");
  } else {
    ok (! exists &$name, "$name() not imported as doesn't exist");
  }
}

exit 0;
