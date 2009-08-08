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
use ExtUtils::MakeMaker;
use lib 'inc';
use MyMakeMakerExtras;

# If WriteMakefile sees conftest.c file it'll add it to O_FILES, which we
# don't want.  In a clean dist conftest.c won't exist, but it can be left
# over if you're fiddling with multiple Makefile.PL runs and builds.
unlink ('conftest.c');

WriteMakefile
  (NAME         => 'Devel::Mallinfo',
   ABSTRACT     => 'Get mallinfo() malloc memory stats.',
   VERSION_FROM => 'lib/Devel/Mallinfo.pm',
   PREREQ_PM    => {
                    'Test::More' => 0,
                    'vars' => 0,
                    'warnings' => 0,
                   },
   AUTHOR       => 'Kevin Ryde <user42@zip.com.au>',
   LICENSE      => 'gpl',
   SIGN         => 1,
   clean => { FILES =>
              "config.h"
              . " conftest.c conftest.i"
              . " conftest\$(OBJ_EXT) conftest\$(EXE_EXT)"
              . " Mallinfo.html" },

   # not sure mallinfo() does anything with Perl's malloc(), but would like
   # Devel::Mallinfo to at least build ...
   PERL_MALLOC_OK => 1,

   EXTRA_META => <<'HERE',
optional_features:
    maximum_tests:
        description: Have "make test" do as much as possible.
        requires:
            Parse::CPAN::Meta: 0
            Test::Pod: 1.00
            Test::NoWarnings: 0
            Test::DistManifest: 0
            Test::YAML::Meta: 0
            YAML: 0
            YAML::Syck: 0
            YAML::Tiny: 0
            YAML::XS: 0
no_index:
    directory:
        - devel
        - inc
        - t
resources:
    homepage: http://user42.tuxfamily.org/devel-mallinfo/index.html
    license: http://www.gnu.org/licenses/gpl.html
HERE
  );

#------------------------------------------------------------------------------
package MY;

sub constants {
  my ($makemaker) = @_;

  # generated at build time
  push @{$makemaker->{H}}, 'config.h';

  # don't install this
  delete ${$makemaker->{PM}}{'config.pl'};

  return $makemaker->SUPER::constants;
}

sub postamble {
  my ($makemaker) = @_;
  $makemaker->{'MyMakeMakerExtras_Pod_Coverage'} = [ 'Devel::Mallinfo' ];
  $makemaker->{'MyMakeMakerExtras_XS'} = 1;
  return MyMakeMakerExtras::postamble($makemaker) . <<'HERE';

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

Mallinfo.html: lib/Devel/Mallinfo.pm Makefile
	-perl -MPod::Simple::HTML -e Pod::Simple::HTML::go \
	  lib/Devel/Mallinfo.pm >Mallinfo.html

HERE
}
