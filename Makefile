#
#  $Id: Makefile,v 1.3 2005/08/19 22:47:39 jonny Exp $
#

BINDIR=/usr/local/bin
BINDIR=~/bin

lockf: lockf.c err.c err.h
	gcc -s -Wall -O2 -o lockf lockf.c err.c

clean:
	rm -f lockf lockf.exe

# O motivo dessa configuração estranha é o suporte ao CygWin
install: lockf
	if [ -f lockf.exe ] ; then	  \
	  strip lockf.exe		; \
	  cp lockf.exe ${BINDIR}	; \
	else				  \
	  strip lockf			; \
	  cp lockf ${BINDIR}		; \
	fi

# EOF
