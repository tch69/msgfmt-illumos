#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2006 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
#       Copyright (c) 1984, 1986, 1987, 1988, 1989 AT&T
#         All Rights Reserved
#
# Copyright 2017 Joyent, Inc.
#

CC ?= cc
LEX ?= lex
YACC ?= yacc

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man

PROGS = gmsgfmt msgfmt xgettext
MAN = msgfmt.1 xgettext.1

all: $(PROGS)

XOBJS =	xgettext.o
LXOBJS=	xgettext.lx.o
GOBJS =	gnu_msgfmt.o gnu_handle.o gnu_lex.o gnu_hash.o gnu_check.o
YOBJS =	gnu_po.o
BOBJS =	gnu_msgs.o
SOBJS =	msgfmt.o check_header.o
COBJS =	option.o util.o

YFLAGS += -d
CFLAGS += -Wno-parentheses -Wno-unused-label -Wno-unused-variable
LDFLAGS += -s

gnu_po.c y.tab.h: gnu_po.y
	$(YACC) -d gnu_po.y
	mv y.tab.c gnu_po.c

gnu_lex.o: y.tab.h

msgfmt:	$(SOBJS) $(COBJS)
	$(CC) $(SOBJS) $(COBJS) -o $@ $(LDFLAGS)

gmsgfmt: $(GOBJS) $(YOBJS) $(BOBJS) $(COBJS)
	$(CC) $(GOBJS) $(YOBJS) $(BOBJS) $(COBJS) -o $@ $(LDFLAGS)

xgettext: $(XOBJS) $(LXOBJS)
	$(CC) $(XOBJS) $(LXOBJS) -o $@ $(LDFLAGS)

install:
	install -d $(DESTDIR)/$(BINDIR)
	install -d $(DESTDIR)/$(MANDIR)
	install -s -m 755 $(PROGS) \
		$(DESTDIR)/$(BINDIR)
	install -m 644 $(MAN) \
		$(DESTDIR)/$(MANDIR)/man1/

uninstall:
	for i in $(PROGS); do \
		rm -f $(DESTDIR)/$(BINDIR)/$$i; \
	done
	for i in $(MAN); do \
		rm -f $(DESTDIR)/$(MANDIR)/$$i; \
	done

clean:
	rm -f $(SOBJS) $(GOBJS) $(YOBJS) $(COBJS) \
		$(XOBJS) $(LXOBJS) $(BOBJS) $(LOBJS) \
		$(POFILE) $(POFILES) $(PROGS) gnu_po.c y.tab.h xgettext.lx.c
