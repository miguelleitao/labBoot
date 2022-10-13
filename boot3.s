#	boot3.s

entry start
	org 0x0000
start:
	jmp 	Inicio
	nop
SuperBlock:
				; Informacao sobre a organizacao da particao
				
				;	BytesPerSec
				;	SecPerClust
				;	ResSectors
				;	FATs
				;	RootDirEnts
				;	Sectors
				;	Media
				;	FATsecs
				;	SecPerTrack
				;	Heads
				;	Hidden
				;	HugeSectors


	org 0x0050
Inicio:
	cli
	cld
	mov ax,#0x9000
	mov ss,ax
	mov ax, #0x07c0	
	mov ds,ax		 
	mov sp,#0000
	mov si, #myMsg		; Ponteiro para o deslocamento da string
	call PString		; Chamar a rotina de impressao
	sti
        mov si, #BLoaderMsg  	; Ponteiro para o deslocamento da string
        call PString    	; Chamar a rotina de impressao

SemFim:
  	jmp SemFim	; Loop infinito

; Procedimentos
PString:			; Marcador do inicio da sub-rotina
  	mov ah, #0x0E		; Indica a rotina de teletipo da BIOS
  	mov bx, #0x0007		; Texto branco em fundo preto

next:	; Marcador interno para inicio do loop
    	lodsb		; Copia o byte em DS:SI para AL e incrementa SI
    	or al,al	; Verifica se al = 0
    	jz volta	; Se al=0, string terminou e salta para .volta
    	int 0x10	; Se nao, chama INT 10 para imprimir caracter
    	jmp next	; Vai para o inicio do loop

volta:
    	ret		; Retorna 'a rotina principal

; Dados
myMsg:
	.ascii	"Arquitectura de Computadores"
	db 13,10,0
BLoaderMsg:
	.ascii  "Isto e' um Boot code"
	db 13,10,0


#	org	510
#	db 0x55,0xAA		; Poe a assinatura do boot loader no final



