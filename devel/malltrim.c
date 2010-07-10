/* Copyright 2010 Kevin Ryde

   This file is part of Devel-Mallinfo.

   Devel-Mallinfo is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the Free
   Software Foundation; either version 3, or (at your option) any later
   version.

   Devel-Mallinfo is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
   or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
   for more details.

   You should have received a copy of the GNU General Public License along
   with Devel-Mallinfo.  If not, see <http://www.gnu.org/licenses/>.
*/

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <malloc.h>
#include <unistd.h>


int
main (void)
{
  int ret;
  struct mallinfo m;

  malloc (123);

  free (malloc (4000));

  m = mallinfo();
  printf ("keepcost %d\n", m.keepcost);

  ret = malloc_trim(0);
  printf ("ret %d\n", ret);

  m = mallinfo();
  printf ("keepcost %d\n", m.keepcost);

  ret = malloc_trim(0);
  printf ("ret %d\n", ret);

  m = mallinfo();
  printf ("keepcost %d\n", m.keepcost);

  return 0;
}
