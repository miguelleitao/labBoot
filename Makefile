## -----------------------------------------------------------------------
##   
##   ISEP, Arquitectura de Computadores
##
##   This program is free software; you can redistribute it and/or modify
##   it under the terms of the GNU General Public License as published by
##   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
##   Boston MA 02111-1307, USA; either version 2 of the License, or
##   (at your option) any later version; incorporated herein by reference.
##
## -----------------------------------------------------------------------

##
## Makefile for boot samples
##

gcc_ok   = $(shell if gcc $(1) -c -x c /dev/null -o /dev/null 2>/dev/null; \
	           then echo $(1); else echo $(2); fi)

M32     := $(call gcc_ok,-m32,)

CC         = gcc
LD         = ld -m elf_i386
AR	   = ar
NASM	   = nasm
AS	   = as86
LD86	   = ld86
RANLIB	   = ranlib
CFLAGS     = $(M32) -mregparm=3 -DREGPARM=3 -W -Wall -march=i386 -Os -fomit-frame-pointer -Iinclude -D__COM32__
LNXCFLAGS  = -W -Wall -O -g -Iinclude
LNXSFLAGS  = -g
LNXLDFLAGS = -g
SFLAGS     = -D__COM32__ -march=i386
LIBDIR     = syslinux/bios/com32
#LDFLAGS    = -T lib/com32.ld 
LDFLAGS	   = -shared -T syslinux/com32/lib/i386/elf.ld -as-needed --hash-style=gnu 
OBJCOPY    = objcopy
LIBGCC    := $(shell $(CC) --print-libgcc)
#LIBS	   = lib/libutil_com.a lib/libcom32.a $(LIBGCC)
LIBS	   = ${LIBDIR}/libutil/libutil.c32 ${LIBDIR}/gpllib/libgpl.c32 ${LIBDIR}/lib/libcom32.c32

.SUFFIXES: .c .o .elf .c32 .s .bin


nothing:

TARGETS = boot1.bin boot2.bin boot3.bin boot5.c32

all: ${TARGETS}

.PRECIOUS: %.bin
%.bin: %.o
	$(LD86) -d $< -o $@


.PRECIOUS: %.o
%.o: %.S
	$(CC) $(SFLAGS) -c -o $@ $<

.PRECIOUS: %.o
%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

%.o: %.s
	$(AS) $< -o $@

#.PRECIOUS: %.elf
%.elf: %.o $(LIBS)
	$(LD) $(LDFLAGS) -o $@ $^

%.c32: %.elf
	$(OBJCOPY) --strip-debug --strip-unneeded  $< $@

tidy:
	rm -f *.o *.lo *.a *.lst *.elf

clean: tidy
	rm -f *.lss *.c32 *.lnx *.com ${TARGETS} *.img

spotless: clean
	rm -f *~ \#*

install:	# Don't install samples

requirements:
	dnf install dev86
	dnf install glibc-devel.i686
	dnf install syslinux

boot5.elf: boot5.o $(LIBS)
	$(LD) $(LDFLAGS) -o $@ $^

$(LIBS) libs: syslinux
	make -C syslinux

submodules:
	git submodule update --init --recursive --remote
