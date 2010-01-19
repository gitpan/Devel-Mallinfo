#!/usr/bin/perl

# Copyright 2010 Kevin Ryde

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

use 5.006;
use strict;
use warnings;
use Test::More;

my $have_test_weaken = eval "use Test::Weaken 3.002; 1";
if (! $have_test_weaken) {
  plan skip_all => "due to Test::Weaken 3.002 not available -- $@";
}
plan tests => 3;

SKIP: { eval 'use Test::NoWarnings; 1'
          or skip 'Test::NoWarnings not available', 1; }

diag ("Test::Weaken version ", Test::Weaken->VERSION);


#-----------------------------------------------------------------------------
# mallinfo()

require Devel::Mallinfo;
{
  my $leaks = Test::Weaken::leaks
    ({ constructor => sub {
         return \(Devel::Mallinfo::mallinfo());
       },
     });
  is ($leaks, undef, 'mallinfo() deep garbage collection');
  if ($leaks && defined &explain) {
    diag "Test-Weaken ", explain $leaks;
  }
}

#-----------------------------------------------------------------------------
# malloc_info_string(), checking mortalize on the newsv

SKIP: {
  defined &Devel::Mallinfo::malloc_info_string
    or skip 'malloc_info_string() not available', 1;

  my $leaks = Test::Weaken::leaks
    ({ constructor => sub {
         return \(Devel::Mallinfo::malloc_info_string(0));
       },
     });
  is ($leaks, undef, 'malloc_info_string() deep garbage collection');
  if ($leaks && defined &explain) {
    diag "Test-Weaken ", explain $leaks;
  }
}

exit 0;
