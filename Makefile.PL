#!/usr/bin/perl

# Copyright 2007, 2008 Kevin Ryde

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


require 5.006; # for "our" in Mallinfo.pm
use ExtUtils::MakeMaker;

# If WriteMakefile sees conftest.c file it'll add it to O_FILES, which we
# don't want.  In a clean dist conftest.c won't exist, but it can be left
# over if you're fiddling with multiple Makefile.PL runs and builds.
unlink ('conftest.c');

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
              . " conftest.c conftest.i"
              . " conftest\$(OBJ_EXT) conftest\$(EXE_EXT)"
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
	$(PERL) config.pl "$(MAKE)" "$(OBJ_EXT)" "$(EXE_EXT)"

# A reasonable "make" should already have a default rule for obj->exe, or at
# least for c->exe, but that's apparently not the case for dmake on msdos,
# and MakeMaker doesn't generate one, hence this rule for the config tests.
# PERL_ARCHIVE is meant for a dynamic extension, which is what Mallinfo.xs
# will be, but not sure if it's correct in a plain .exe link. 
#
conftest$(EXE_EXT): conftest$(OBJ_EXT)
	$(LD) $(LDFLAGS) conftest$(OBJ_EXT) $(OTHERLDFLAGS) \
	  $(PERL_ARCHIVE) $(LDLOADLIBS) $(PERL_ARCHIVE_AFTER) \
	  -o $@

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

# find files in the dist with mod times this year, but without this year in
# the copyright line
copyright-years-check: $(DISTVNAME).tar.gz
	year=`date +%Y`; \
	tar tvfz $(DISTVNAME).tar.gz \
	| grep $$year- \
	| sed 's:^.*$(DISTVNAME)/::' \
	| (result=0; \
	  while read i; do \
	    case $$i in \
	      '' | */ | MANIFEST | META.yml | SIGNATURE \
	      | t/pod.t \
	      | debian/changelog | debian/compat | debian/control) \
	      continue ;; \
	    esac; \
	    if test -e "$(srcdir)/$$i"; then f="$(srcdir)/$$i"; \
	    else f="$$i"; fi; \
	    if ! grep -q "Copyright.*$$year" $$f; then \
	      echo "$$i:1: this file"; \
	      grep Copyright $$f; \
	      result=1; \
	    fi; \
	  done; \
	  exit $$result)

MAKE_FRAG
}
