
PREFIX=/usr/local
BINDIR=$(PREFIX)/bin
MANDIR=$(PREFIX)/share/man/man1

# Detect Cygwin and set EXE extension accordingly
UNAME_S := $(shell uname -s 2>/dev/null)
ifeq ($(findstring CYGWIN,$(UNAME_S)),CYGWIN)
EXEEXT := .exe
else
EXEEXT :=
endif

TARGET := lockf$(EXEEXT)

$(TARGET): lockf.c err.c err.h
	gcc -s -Wall -O3 -o $(TARGET) lockf.c err.c

clean:
	rm -f $(TARGET)

install: $(TARGET) lockf.1
	install -d $(BINDIR) $(MANDIR)
	install -s -m 755 $(TARGET) $(BINDIR)
	install -m 644 lockf.1 $(MANDIR)

# RPM build helpers
RPM_TOPDIR := $(CURDIR)/rpmbuild
VERSION := $(shell sed -n 's/^Version:[[:space:]]*//p' lockf.spec | head -n1)

.PHONY: dist srpm rpm distclean

dist:
	mkdir -p dist
	tar czf dist/lockf-$(VERSION).tar.gz --transform 's,^,lockf-$(VERSION)/,' lockf.c err.c err.h lockf.1 Makefile README

srpm: dist
	mkdir -p $(RPM_TOPDIR)/BUILD $(RPM_TOPDIR)/RPMS $(RPM_TOPDIR)/SOURCES $(RPM_TOPDIR)/SPECS $(RPM_TOPDIR)/SRPMS
	cp lockf.spec $(RPM_TOPDIR)/SPECS/
	cp dist/lockf-$(VERSION).tar.gz $(RPM_TOPDIR)/SOURCES/
	rpmbuild -bs --define "_topdir $(RPM_TOPDIR)" $(RPM_TOPDIR)/SPECS/lockf.spec

rpm: srpm
	rpmbuild -ba --define "_topdir $(RPM_TOPDIR)" $(RPM_TOPDIR)/SPECS/lockf.spec

distclean: clean
	rm -rf dist $(RPM_TOPDIR)

# EOF
