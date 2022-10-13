# boot1.s
# modified from code published by Krishakumar R.
# in Linux Gazette, Issue 77.
#

VRAM_SEG=0xb800         # VRAM is at 0xb8000
ATTR=0x1f               # Attributes for printed text
CHAR='A'

entry start
start:
        mov ax, #VRAM_SEG
        mov ds, ax
        movb [0],#CHAR
        movb [1],#ATTR
loop1:  jmp loop1

