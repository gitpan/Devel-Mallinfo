#!/usr/bin/perl -w

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
use Test::More;

use lib 't';
use MyTestHelpers;
BEGIN { MyTestHelpers::nowarnings(); }

require Devel::Mallinfo;

defined(&Devel::Mallinfo::malloc_info_string)
  or plan skip_all => 'malloc_info_string() not available';

plan tests => 4;


#-----------------------------------------------------------------------------
# malloc_info_string() basic run

{
  # successful return depends on disk space available on /tmp, but think
  # it's ok to expect that when testing
  #
  my $str = Devel::Mallinfo::malloc_info_string(0);
  ok (defined $str, 'malloc_info_string() ran');
}

#-----------------------------------------------------------------------------
# weaken of return value

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
  $have_weaken
    or skip 'weaken() not available', 1;

  my $ref = \(Devel::Mallinfo::malloc_info_string(0));
  Scalar::Util::weaken ($ref);
  is ($ref, undef, 'malloc_info_string() destroyed by weaken');
}

#-----------------------------------------------------------------------------
# malloc_info_string() induced failure from tmpfile()

my $have_bsd_resource = eval { require BSD::Resource; 1 };
if (! $have_bsd_resource) {
  diag "BSD::Resource not available -- $@";
}

my $have_rlimit_nofile;
if ($have_bsd_resource) {
  my $limits = BSD::Resource::get_rlimits();
  $have_rlimit_nofile = defined $limits->{'RLIMIT_NOFILE'};
  if (! $have_rlimit_nofile) { diag "RLIMIT_NOFILE not available"; }
}

# don't think would have RLIMIT_NOFILE but then getrlimit() throwing "not
# implemented on this architecture", but check just in case
my $have_getrlimit;
if ($have_rlimit_nofile) {
  $have_getrlimit = eval {
    BSD::Resource::getrlimit (BSD::Resource::RLIMIT_NOFILE());
    1;
  };
  if (! $have_getrlimit) { diag "getrlimit() not available -- $@"; }
}

# even less likely to have getrlimit() but not then setrlimit(), but check
# just in case
my $have_setrlimit;
if ($have_getrlimit) {
  my ($soft, $hard) = BSD::Resource::getrlimit(BSD::Resource::RLIMIT_NOFILE());
  $have_setrlimit = eval {
    BSD::Resource::setrlimit (BSD::Resource::RLIMIT_NOFILE(), $soft, $hard);
    1;
  };
  if (! $have_setrlimit) { diag "setrlimit() not available -- $@"; }
}

SKIP: {
  $have_setrlimit
    or skip 'setrlimit(RLIMIT_NOFILE) not available', 2;

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
