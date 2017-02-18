
#define start_screen $bb80+40+40

#define status_line $bb80+40

*=$c000
#define RES  $00
#define RESB $02

#define POS $04

start_teletest

	lda #<start_screen
	sta POS

	lda #>start_screen
	sta POS+1
	
	jsr _clean_screen
	jsr _copy_charset
	

	
	lda #<str_teletest
	ldy #>str_teletest
	jsr _print
	
	lda #<str_test_switch
	ldy #>str_test_switch
	jsr _print
	
	jsr _read_bank
loopme
	jmp loopme
	rts

_read_bank
.(
	lda #"B"
	sta $bb80+34
	lda #"A"
	sta $bb80+35
	lda #"N"
	sta $bb80+36
	lda #"K"
	sta $bb80+37

	
	ldx #0
loop	
	lda switch_code,x
	sta $1000,x
	inx
	bne loop
	
	jsr $1000
	
	rts
.)	
	
switch_code
.(
	sei
	lda #6
	sta $321
	
	lda $fff8
	ldy $fff9
	sta RES
	sty RES+1
	
	lda #<status_line
	sta RESB
	
	lda #>status_line
	sta RESB+1
	
	ldy #0
loop
	lda (RES),y
	sta (RESB),y
	iny
	cpy #10
	bne loop
	
	lda $321
	clc
	adc #56
	sta $bb80+39
	
	ldy #0
	
	ldx #0
loop2
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	inx
	bne loop2
	iny 
	bne loop2
	
	

	lda #7
	sta $321
	
	lda $321
	clc
	adc #56
	sta $bb80+39	
	;jsr _print_bank
loop3
	beq loop3
	rts
.)

_wait
.(
	ldx #0
loop	
	ldy #0
	iny
	bne loop
	iny
	bne loop
	rts

.)

_print_bank:

	lda $321
	clc
	adc #56
	sta $bb80+39
	rts
	
_print
.(
	sta RES
	sty RES+1
	
	ldy #0
loop	
	lda (RES),y
	beq exit
	cmp #$13
	beq return_line
	sta (POS),y
	iny
	jmp loop
exit	
	rts
return_line
	lda POS
	clc
	adc #40
	bcc next
	inc POS+1
next
	sta POS

	rts
.)

str_teletest
.asc 1,"TELETEST 3.0",$13,0
str_test_switch
.asc "TESTING ROM SWITCH",$13,0
	
_clean_screen
.(
	ldx #0
	lda #<start_screen
	sta RES
	
	lda #>start_screen
	sta RES+1
	ldy #0
	lda #32
	
	ldx #4
loop
	sta (RES),y
	iny
	bne loop
	inc RES+1
	dex
	bne loop
	rts
.)	

	
_copy_charset
.(
	lda #<fonte
	sta RES
	lda #>fonte
	sta RES+1
	
	lda #<$b400+8*32
	sta RESB
	lda #>$b400+8*32
	sta RESB+1
	
	ldx #2
	
	ldy #0
loop	
	lda (RES),y
	sta (RESB),y
	iny
	bne loop
	inc RES+1
	inc RESB+1
	dex
	bne loop
	rts
.)	

#include "fonte.h"
	

#ifdef NOTROM
#else	
free_bytes ; 26 bytes
	.dsb $ffff-free_bytes-7,0 ; 5 because we have 5 bytes after

; fffa
END_ROM
copyright
	.byt 0
	.byt 0
version_bank
	.byt $00
;$fffb
status_bank
	.byt %11101111 ;
; fffc
RESET:
	.byt <start_teletest,>start_teletest
; fffe
BRK_IRQ:	
	.byt <$2fa,>$2fa
#endif	







