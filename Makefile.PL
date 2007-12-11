#!/usr/bin/perl

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


use ExtUtils::MakeMaker;

WriteMakefile
  (NAME         => 'Devel::Mallinfo',
   ABSTRACT     => 'Get mallinfo() malloc memory stats.',
   VERSION_FROM => 'lib/Devel/Mallinfo.pm',
   PREREQ_PM    => {},
   AUTHOR       => 'Kevin Ryde <user42@zip.com.au>',
   LICENSE      => 'gpl',
   SIGN         => 1,
   clean => { FILES =>
              "config.h"
              . " confmallh.c confmallh\$(EXE_EXT)"
              . " confminfo.c confminfo\$(EXE_EXT) confminfo.i"
              . " Mallinfo.html" },
);

package MY;

sub constants {
  my ($self) = @_;

  # generated at build time
  push @{$self->{H}}, 'config.h';

  # don't install this
  delete ${$self->{PM}}{'config.pl'};

  return $self->SUPER::constants;
}

sub postamble {
    return <<'MAKE_FRAG';

config.h: config.pl Makefile
	$(PERL) config.pl "$(MAKE)" "$(EXE_EXT)"


# some development helpers ...
#
lint:
	perl -MO=Lint lib/Devel/Mallinfo.pm
	perl -MO=Lint config.pl
	podchecker lib/Devel/Mallinfo.pm
myman:
	rm -f MANIFEST
	touch SIGNATURE
	make manifest

Mallinfo.html: lib/Devel/Mallinfo.pm Makefile
	-perl -MPod::Simple::HTML -e Pod::Simple::HTML::go \
	  lib/Devel/Mallinfo.pm >Mallinfo.html

MAKE_FRAG
}
