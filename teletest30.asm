
#include "../oric-common/include/asm/via6522_2.h"

#define start_screen $bb80+40+40+40

#define status_line $bb80+40+40

*=$c000
#define RES  $00
#define RESB $02

#define POS $04

start_teletest
	sei
	CLD
	LDX #$FF
	TXS ; init stack
	
	lda #<start_screen
	sta POS

	lda #>start_screen
	sta POS+1

	; init VIA2
	lda #$07
	sta $323
	
	lda #32
	jsr _clean_screen
	
	lda #27 ; 50hz 
	jsr _clean_screen
	
	jsr _copy_charset
	

	
	lda #<str_teletest
	ldy #>str_teletest
	jsr _print
	
	lda #<str_test_switch
	ldy #>str_test_switch
	jsr _print
	
	lda #"B"
	sta status_line+34-40
	lda #"A"
	sta status_line+35-40
	lda #"N"
	sta status_line+36-40
	lda #"K"
	sta status_line+37-40
	
	jsr _print_bank
	jsr _wait
	
	jsr _read_bank
	
	lda #<str_test_joysticks
	ldy #>str_test_joysticks
	jsr _print
	

	
loopme
	jmp loopme
	rts

_read_bank
.(


	
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
	beq skip
	sta (RESB),y
	iny

	bne loop
skip	
	lda $321
	and #%00000111
	clc
	adc #48
	sta status_line+39-40
	
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
	and #%00000111
	clc
	adc #48
	sta status_line+39-40
	;jsr _print_bank

	rts
.)

_display_current_bank
.(

.)

_wait
.(
	ldy #0
	ldx #0
loop	
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
	bne loop
	iny
	bne loop
	rts
.)

_print_bank:

	lda $321
	and #%00000111
	clc
	adc #48
	sta status_line+39-40
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
str_test_joysticks
.asc "TESTING JOYSTICKS",$13,0	
	
_clean_screen
.(
	
	ldy #<$bb80
	sty RES
	
	ldy #>$bb80
	sty RES+1
	
	ldy #0
	
	
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







