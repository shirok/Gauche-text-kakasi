/*
 * Gauche-text-kakasi binding
 *
 * Copyright (C) 2003  Shiro Kawai (shiro@acm.org)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either versions 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with KAKASI, see the file COPYING.  If not, write to the Free
 * Software Foundation Inc., 59 Temple Place - Suite 330, Boston, MA
 * 02111-1307, USA.
 */

#include <gauche.h>
#include <gauche/extend.h>
#include <libkakasi.h>

extern void Scm_Init_kakasilib(ScmModule *);

void Scm_Init_kakasi(void)
{
    ScmModule *mod;
    SCM_INIT_EXTENSION(kakasi);
    mod = SCM_MODULE(SCM_FIND_MODULE("text.kakasi", TRUE));
    Scm_Init_kakasilib(mod);
}

