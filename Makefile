
SHELL = /bin/bash

# Project settings
VERSION := $(shell sed -n 's/^Version:[[:space:]]*//p' lockf.spec | head -n1)
TARGET := lockf

# Default target
.DEFAULT_GOAL := rpm

.PHONY: build dist srpm rpm install copr clean distclean help

## build: Compile lockf binary locally (for development)
build: lockf.c Makefile
	gcc -s -Wall -O3 -o $(TARGET) lockf.c -lnbcompat

## dist: Create source tarball for RPM build
dist:
	mkdir -p dist
	tar czf dist/lockf-$(VERSION).tar.gz --transform 's,^,lockf-$(VERSION)/,' lockf.c lockf.1 lockf.spec Makefile README

## srpm: Build source RPM package
srpm: dist
	mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
	cp lockf.spec ~/rpmbuild/SPECS/
	cp dist/lockf-$(VERSION).tar.gz ~/rpmbuild/SOURCES/
	rpmbuild -bs ~/rpmbuild/SPECS/lockf.spec
	mkdir -p releases
	cp ~/rpmbuild/SRPMS/lockf-$(VERSION)-*.src.rpm releases/

## rpm: Build binary RPM package (default target)
rpm: srpm
	rpmbuild -ba ~/rpmbuild/SPECS/lockf.spec
	mkdir -p releases
	cp ~/rpmbuild/RPMS/*/lockf-$(VERSION)-*.rpm releases/

## install: Install lockf from the built RPM (requires sudo)
install: rpm
	sudo dnf install -y releases/lockf-$(VERSION)-*.x86_64.rpm

## copr: Submit build to COPR (dioni21/jonny-utils)
copr: srpm
	copr-cli build dioni21/jonny-utils releases/lockf-$(VERSION)-*.src.rpm

## clean: Remove local build artifacts and releases
clean:
	rm -f $(TARGET)
	rm -rf releases

## distclean: Remove all generated files (dist + releases)
distclean: clean
	rm -rf dist releases

## help: Show this help message
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^## ' $(MAKEFILE_LIST) | sed 's/^## /  /'
	@echo ""
	@echo "Current version: $(VERSION)"

# EOF
