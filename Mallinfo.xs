/* Copyright 2007, 2008 Kevin Ryde

   This file is part of Devel-Mallinfo.

   Devel-Mallinfo is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 3, or (at your option) any later
   version.

   Devel-Mallinfo is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
   Public License for more details.

   You should have received a copy of the GNU General Public License along
   with Devel-Mallinfo.  If not, see <http://www.gnu.org/licenses/>. */

#include "config.h"

#include <stdlib.h>
#if HAVE_MALLOC_H
#include <malloc.h>
#endif

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#define NEED_newRV_noinc
#include "ppport.h"

MODULE = Devel::Mallinfo   PACKAGE = Devel::Mallinfo

SV *
mallinfo ()
PROTOTYPE:
CODE:
  {
    HV *h;
    SV *href;
#if HAVE_MALLINFO
    struct mallinfo m;

    /* grab the info before building the hash return, so as not to include
       that in "current" usage */
    m = mallinfo();
#endif
    h = newHV();
    href = newRV_noinc ((SV*) h);
    RETVAL = href;
/**/
#if HAVE_MALLINFO
#define FIELD(field)                                    \
  do {                                                  \
    SV *val = newSViv (m.field);                        \
    if (! hv_store (h, #field, strlen(#field), val, 0)) \
      goto store_error;                                 \
  } while (0)

    STRUCT_MALLINFO_FIELDS;
    goto done;

  store_error:
    croak ("cannot store to hash");
  done:
    ;
#endif
  }
OUTPUT:
    RETVAL
