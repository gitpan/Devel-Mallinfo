#!/usr/bin/perl

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

use strict;
use warnings;
use Devel::Mallinfo;
use Test::More tests => 8;

SKIP: { eval 'use Test::NoWarnings; 1'
          or skip 'Test::NoWarnings not available', 1; }

my $want_version = 4;
cmp_ok ($Devel::Mallinfo::VERSION,'>=',$want_version, 'VERSION variable');
cmp_ok (Devel::Mallinfo->VERSION, '>=',$want_version, 'VERSION class method');
{ ok (eval { Devel::Mallinfo->VERSION($want_version); 1 },
      "VERSION class check $want_version");
  my $check_version = $want_version + 1000;
  ok (! eval { Devel::Mallinfo->VERSION($check_version); 1 },
      "VERSION class check $check_version");
}

# not imported into namespace by default
ok (! defined &mallinfo,
    'mallinfo() should not be defined in local module');

# but directly callable
ok (defined &Devel::Mallinfo::mallinfo,
    'but full Devel::Mallinfo::mallinfo() should not be defined');

# get back a hash, though what it contains is system-dependent
my $h = Devel::Mallinfo::mallinfo();
is (ref($h), 'HASH',
    'mallinfo() returns hash');

exit 0;
