# boot2.s
#

CHAR='R'

entry start

start:
        mov     ah, #0x0E
	mov	bh, #0x00
	mov	bl, #0x07
	mov 	al, #CHAR
        int     0x10
loop1:  jmp     loop1


