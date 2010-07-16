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

package MyWithoutGNU;
use strict;
use warnings;
use Devel::Mallinfo;

undef &Devel::Mallinfo::malloc_info;
undef &Devel::Mallinfo::malloc_info_string;
undef &Devel::Mallinfo::malloc_stats;
undef &Devel::Mallinfo::malloc_trim;
1;