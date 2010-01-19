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
use Test::More tests => 5;

SKIP: { eval 'use Test::NoWarnings; 1'
          or skip 'Test::NoWarnings not available', 1; }

require Devel::Mallinfo;

#-----------------------------------------------------------------------------
# malloc_info() basic run

SKIP: {
  defined &Devel::Mallinfo::malloc_info
    or skip 'malloc_info() not available', 2;

  Devel::Mallinfo::malloc_info(0,\*STDERR);
  ok (1, 'malloc_info() ran successfully');

  my $str = Devel::Mallinfo::malloc_info_string(0);
  ok (defined $str, 'malloc_info_string() return successful');
}

#-----------------------------------------------------------------------------
# malloc_info() induced failure from tmpfile()

SKIP: {
  defined &Devel::Mallinfo::malloc_info
    or skip 'malloc_info() not available', 2;
  eval { require BSD::Resource; 1 }
    or skip 'BSD::Resource not available', 2;
  my $limits = BSD::Resource::get_rlimits();
  defined $limits->{'RLIMIT_NOFILE'}
    or skip 'RLMIT_NOFILE not available', 2;

  my ($soft, $hard) = BSD::Resource::getrlimit(BSD::Resource::RLIMIT_NOFILE());
  diag "RLIMIT_NOFILE soft $soft hard $hard";

  BSD::Resource::setrlimit (BSD::Resource::RLIMIT_NOFILE(), 0, $hard);
  my $str = Devel::Mallinfo::malloc_info_string(0);
  my $err = $!;
  BSD::Resource::setrlimit (BSD::Resource::RLIMIT_NOFILE(), $soft, $hard);

  require POSIX;
  is ($str, undef,
      'malloc_info_string() undef under NOFILE');
  is ($err+0, POSIX::EMFILE(),
      'malloc_info_string() errno EMFILE under NOFILE');
}

exit 0;
