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

use strict;
use warnings;
use Test::More tests => 3;

SKIP: { eval 'use Test::NoWarnings; 1'
          or skip 'Test::NoWarnings not available', 1; }

require Devel::Mallinfo;

#-----------------------------------------------------------------------------
# malloc_info_string() basic run

SKIP: {
  defined &Devel::Mallinfo::malloc_info_string
    or skip 'malloc_info_string() not available', 1;

  # successful return depends on disk space available on /tmp, but think
  # it's ok to expect that when testing
  #
  my $str = Devel::Mallinfo::malloc_info_string(0);
  ok (defined $str, 'malloc_info_string() ran');
}

#-----------------------------------------------------------------------------
# weaken

my $have_scalar_util = eval { require Scalar::Util; 1 };
if (! $have_scalar_util) {
  diag "Scalar::Util not available: $@";
}

my $have_weaken;
if ($have_scalar_util) {
  $have_weaken = do {
    my $ref = [];
    eval { Scalar::Util::weaken ($ref); 1 }
  };
  if (! $have_weaken) {
    diag "weaken() not available: $@";
  }
}

SKIP: {
  defined &Devel::Mallinfo::malloc_info_string
    or skip 'malloc_info_string() not available', 1;
  $have_weaken
    or skip 'weaken() not available', 1;

  my $ref = \(Devel::Mallinfo::malloc_info_string(0));
  Scalar::Util::weaken ($ref);
  is ($ref, undef, 'malloc_info_string() destroyed by weaken');
}

exit 0;
