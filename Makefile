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

BOOT_DEV=/dev/sda

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
LDFLAGS	   = -shared -T syslinux/com32/lib/i386/elf.ld -as-needed --hash-style=gnu -z notext
OBJCOPY    = objcopy
LIBGCC    := $(shell $(CC) --print-libgcc)
#LIBS	   = lib/libutil_com.a lib/libcom32.a $(LIBGCC)
LIBS	   = ${LIBDIR}/libutil/libutil.c32 ${LIBDIR}/gpllib/libgpl.c32 ${LIBDIR}/lib/libcom32.c32

.SUFFIXES: .c .o .elf .c32 .s .bin


nothing:

TARGETS = boot1.bin boot2.bin boot3.bin boot5.c32 BOOTX64.EFI

all: ${TARGETS}

/dev/BootDev:
	@echo "Please make /dev/BootDevice a link to your boot device." 
	$(error no /dev/BootDev found. Please make /dev/BootDevice a link to your boot device.)

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

clear_boot_device: ${BOOT_DEV}
	dd if=/dev/zero of=${BOOT_DEV} bs=1k count=10000

submodules:
	git submodule update --init --recursive --remote

BOOTX64.EFI: boot6.so
	objcopy \
                -j .text \
                -j .sdata \
                -j .data \
                -j .rodata \
                -j .dynamic \
                -j .dynsym \
                -j .rel \
                -j .rela \
                -j .reloc \
                -O efi-app-x86_64 $< $@

boot6.so: boot6.o
	ld -nostdlib -znocombreloc -T /usr/lib/elf_x86_64_efi.lds -shared -Bsymbolic /usr/lib/crt0-efi-x86_64.o $< -L /usr/lib -lefi -lgnuefi -o $@

boot6.o: boot6.c
	gcc -I/usr/include/efi -I/usr/include/efi/x86_64 -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -Wall -c $< -o $@ 

UEFI_IMG  := uefi-gpt.img
UEFI_APP  := BOOTX64.EFI
UEFI_MNT  := /mnt/labboot-uefi

uefi-image:
	@echo "Creating $(UEFI_IMG)..."
	@rm -f "$(UEFI_IMG)"
	@dd if=/dev/zero of="$(UEFI_IMG)" bs=1M count=128 status=progress
	@printf 'g\nn\n1\n\n\nt\n1\np\nw\n' | fdisk "$(UEFI_IMG)"

# Formatar a ESP e instalar a aplicacao UEFI.

uefi-install: $(UEFI_APP) $(UEFI_IMG)
	@set -eu; \
	LOOP=$$(losetup --find --show --partscan "$(UEFI_IMG)"); \
	echo "Loop device: $$LOOP"; \
	cleanup() { \
	    umount "$(UEFI_MNT)" 2>/dev/null || true; \
	    losetup --detach "$$LOOP" 2>/dev/null || true; \
	}; \
	trap cleanup EXIT INT TERM; \
	echo "Formatting $${LOOP}p1 as FAT32..."; \
	mkfs.fat -F 32 -n EFI "$${LOOP}p1"; \
	mkdir -p "$(UEFI_MNT)"; \
	mount "$${LOOP}p1" "$(UEFI_MNT)"; \
	echo "Installing $(UEFI_APP)..."; \
	mkdir -p "$(UEFI_MNT)/EFI/BOOT"; \
	cp "$(UEFI_APP)" "$(UEFI_MNT)/EFI/BOOT/BOOTX64.EFI"; \
	sync; \
	echo; \
	echo "Files installed in the ESP:"; \
	find "$(UEFI_MNT)" -type f -print; \
	echo; \
	echo "Application checksum:"; \
	sha256sum "$(UEFI_APP)"; \
	sha256sum "$(UEFI_MNT)/EFI/BOOT/BOOTX64.EFI"; \
	umount "$(UEFI_MNT)"; \
	losetup --detach "$$LOOP"; \
	trap - EXIT INT TERM; \
	echo "Installation completed."

uefi-run: $(UEFI_IMG)
	qemu-system-x86_64 \
		-machine q35 \
		-m 256M \
		-bios /usr/share/edk2/ovmf/OVMF_CODE.fd \
		-drive file="$(UEFI_IMG)",format=raw,if=virtio

esp-test-run: BOOTX64.EFI
	rm -rf $@
	mkdir -p esp-test/EFI/BOOT
	cp BOOTX64.EFI esp-test/EFI/BOOT/BOOTX64.EFI
	qemu-system-x86_64 -m 256M -bios /usr/share/edk2/ovmf/OVMF_CODE.fd -drive format=raw,file=fat:rw:esp-test



