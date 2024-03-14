
.include   "telestrat.inc"
.include   "fcntl.inc"


start_screen                     := $bb80+40+40+40
.define write_ram_overlay_in_ram $3300
.define status_line              $bb80+40+40
.define switch_code_in_ram       $2000
.define print_bank_code_in_ram   $2100
.define print_code_in_ram        $2200


.define COLOR_LONGTEST $5000

.define RETURN_LINE_TOKEN $13

.define posx TR0
.define posy TR1
.define POS  TR2
.define switch_current_bank TR3

.define ADDR_SCREEN  RESB
.define PTR_STRING    TR4


.org $c000
.code
rom_start:
start_teletest:

  sei

  cld
  ldx     #$FF
  txs ; init stack

  lda     #27 ; 50hz
  jsr     _clean_screen

  lda     #32
  jsr     _clean_screen

  lda     #$07+128+32 ; 0001 0111
  sta     VIA2::PRA
  sta     VIA2::DDRA

  jsr     _copy_charset



  ldx     #$00
  stx     posx
  stx     posy

  lda     #<$bb80
  sta     ADDR_SCREEN
  ldy     #>$bb80
  sty     ADDR_SCREEN+1
  jsr     twi_display_signature

  jsr     twi_crlf

  lda     #<str_starting_test_bank_switching
  ldy     #>str_starting_test_bank_switching
  jsr     twi_print

  jsr     twi_crlf

  ldx     #$07
  stx     RES

@loop_all_banks:
  ldx     RES
  stx     VIA2::PRA

  jsr     twi_crlf

  lda     #<rom_signature
  ldy     #>rom_signature

  jsr     twi_print

  dec     RES
  bne     @loop_all_banks

  jsr     test_overlay_ram

@me:
  jmp   @me


@exit_all_signature:

  lda     #$11
  sta     COLOR_LONGTEST


@LOOPME:
  jsr     _long_test
  jsr     write_ram_overlay_in_ram
  lda     #$14
  sta     $BB80+500
  jmp     @LOOPME
  ;jsr  _long_test
 ; jsr init_via
  rts

.proc _long_test
; This test is use eeprom and ram video only
  ldx #$00


@L1:
  lda COLOR_LONGTEST
  cmp #$17
  beq @init_agan
  sta $bb80,x
  inc COLOR_LONGTEST
  inx
  bne @L1

  rts

@init_agan:
  lda #$11
  sta COLOR_LONGTEST
  jmp @L1

.endproc

.proc _clean_screen
	ldy #<$BB80
	sty RES

	ldy #>$BB80
	sty RES+1

	ldy #$00

	ldx #$04

@L1:
	sta (RES),y
	iny
	bne @L1
	inc RES+1
	dex
	bne @L1

@L2:
  sta (RES),y
  iny
  cpy #40*2+8+80
  bne @L2

  lda #<start_screen
  sta POS

  lda #>start_screen
  sta POS+1

	rts
.endproc

.proc _copy_code_256
  sta     RESB
  sty     RESB+1

	ldx     #$00

loop:
  lda     (RESB),y
  sta     write_ram_overlay_in_ram,y
  inx
  bne     loop
  rts
.endproc


.proc _copy_code_512
  sta     RESB
  sty     RESB+1

  lda     #<write_ram_overlay_in_ram
  sta     RES

  lda     #>write_ram_overlay_in_ram
  sta     RES+1

	ldx     #$02
  ldy     #$00

@loop:
  lda     (RESB),y
  sta     (RES),y
  iny
  bne     @loop
  inc     RES+1
  inc     RESB+1
  dex
  bne     @loop
  rts
.endproc

fonte:
	.byt $40,$40,$40,$40,$40,$40,$40,$40,$4c,$4c,$4c,$4c,$4c,$40,$4c,$40
	.byt $54,$54,$54,$40,$40,$40,$40,$40,$54,$54,$7e,$54,$7e,$54,$54,$40
	.byt $48,$5e,$68,$5c,$4a,$7c,$48,$40,$70,$72,$44,$48,$50,$66,$46,$40
	.byt $50,$68,$68,$50,$6a,$64,$5a,$40,$48,$48,$48,$40,$40,$40,$40,$40
	.byt $4c,$50,$70,$70,$70,$50,$4c,$40,$58,$44,$46,$46,$46,$44,$58,$40
	.byt $48,$6a,$5c,$48,$5c,$6a,$48,$40,$40,$48,$48,$7e,$48,$48,$40,$40
	.byt $40,$40,$40,$40,$40,$4c,$4c,$58,$40,$40,$40,$7e,$40,$40,$40,$40
	.byt $40,$40,$40,$40,$40,$4c,$40,$40,$40,$42,$44,$48,$50,$60,$40,$40
	.byt $5c,$62,$62,$40,$62,$62,$5c,$40,$40,$42,$42,$40,$42,$42,$40,$40
	.byt $5c,$42,$42,$5c,$60,$60,$5c,$40,$5c,$42,$42,$5c,$42,$42,$5c,$40
	.byt $40,$62,$62,$5c,$42,$42,$40,$40,$5c,$60,$60,$5c,$42,$42,$5c,$40
	.byt $5c,$60,$60,$5c,$62,$62,$5c,$40,$5c,$42,$42,$40,$42,$42,$40,$40
	.byt $5c,$62,$62,$5c,$62,$62,$5c,$40,$5c,$62,$62,$5c,$42,$42,$5c,$40
	.byt $40,$40,$4c,$40,$40,$4c,$40,$40,$40,$40,$4c,$40,$40,$4c,$4c,$58
	.byt $44,$48,$50,$60,$50,$48,$44,$40,$40,$40,$7e,$40,$7e,$40,$40,$40
	.byt $50,$48,$44,$42,$44,$48,$50,$40,$5c,$62,$44,$48,$48,$40,$48,$40
	.byt $5c,$62,$6a,$6e,$6c,$60,$5e,$40,$78,$44,$72,$72,$7e,$72,$72,$40
	.byt $78,$44,$72,$7c,$72,$72,$7c,$40,$7e,$40,$70,$70,$70,$70,$7e,$40
	.byt $78,$44,$72,$72,$72,$72,$7c,$40,$7e,$40,$70,$7c,$70,$70,$7e,$40
	.byt $7e,$40,$70,$7c,$70,$70,$70,$40,$7e,$40,$70,$70,$76,$72,$5e,$40
	.byt $72,$42,$72,$7e,$72,$72,$72,$40,$5e,$40,$4c,$4c,$4c,$4c,$5e,$40
	.byt $46,$40,$46,$46,$46,$66,$5e,$40,$72,$42,$74,$78,$74,$72,$72,$40
	.byt $70,$40,$70,$70,$70,$70,$7e,$40,$72,$4e,$72,$72,$72,$72,$72,$40
	.byt $72,$42,$72,$7a,$76,$72,$72,$40,$5c,$42,$72,$72,$72,$72,$5c,$40
	.byt $7c,$42,$72,$7c,$70,$70,$70,$40,$5c,$42,$72,$72,$72,$74,$5a,$40
	.byt $7c,$42,$72,$7c,$78,$74,$72,$40,$7e,$42,$70,$7e,$42,$72,$7e,$40
	.byt $7c,$40,$58,$58,$58,$58,$58,$40,$72,$42,$72,$72,$72,$72,$5c,$40
	.byt $72,$42,$72,$72,$72,$74,$78,$40,$72,$42,$72,$72,$72,$7e,$72,$40
	.byt $72,$42,$54,$48,$54,$72,$72,$40,$72,$42,$72,$54,$48,$48,$48,$40
	.byt $7e,$40,$46,$4c,$58,$70,$7e,$40,$5e,$50,$50,$50,$50,$50,$5e,$40
	.byt $40,$60,$50,$48,$44,$42,$40,$40,$7c,$44,$44,$44,$44,$44,$7c,$40
	.byt $48,$54,$6a,$48,$48,$48,$48,$40,$4e,$50,$50,$50,$7c,$50,$7e,$40
	.byt $5e,$61,$6d,$69,$69,$6d,$61,$5e,$40,$40,$5e,$42,$7e,$72,$7e,$40
	.byt $70,$70,$7e,$72,$72,$72,$7e,$40,$40,$40,$7e,$70,$70,$70,$7e,$40
	.byt $42,$42,$7e,$72,$72,$72,$7e,$40,$40,$40,$7e,$72,$7e,$70,$7c,$40
	.byt $7e,$70,$70,$7c,$70,$70,$70,$40,$40,$40,$7e,$72,$72,$7e,$42,$5e
	.byt $70,$70,$7c,$72,$72,$72,$72,$40,$40,$58,$40,$58,$58,$58,$58,$40
	.byt $40,$4c,$40,$4c,$4c,$4c,$6c,$5c,$70,$70,$72,$74,$78,$74,$72,$40
	.byt $58,$58,$58,$58,$58,$58,$58,$40,$40,$40,$72,$7e,$72,$72,$72,$40
	.byt $40,$40,$7c,$72,$72,$72,$72,$40,$40,$40,$7e,$72,$72,$72,$7e,$40
	.byt $40,$40,$7e,$72,$72,$7e,$70,$70,$40,$40,$7e,$72,$72,$7e,$42,$42
	.byt $40,$40,$7e,$70,$70,$70,$70,$40,$40,$40,$7e,$70,$7e,$42,$7e,$40
	.byt $70,$70,$7c,$70,$70,$70,$7c,$40,$40,$40,$72,$72,$72,$72,$5e,$40
	.byt $40,$40,$72,$72,$72,$74,$78,$40,$40,$40,$72,$72,$72,$7e,$72,$40
	.byt $40,$40,$72,$5c,$48,$5c,$72,$40,$40,$40,$72,$72,$72,$7e,$42,$5e
	.byt $40,$40,$7e,$46,$4c,$58,$7e,$40,$4e,$58,$58,$70,$58,$58,$4e,$40
	.byt $48,$48,$48,$48,$48,$48,$48,$48,$78,$4c,$4c,$46,$4c,$4c,$78,$40


.proc _copy_charset
	lda #<fonte
	sta RES
	lda #>fonte
	sta RES+1

	lda #<($b400+8*32)
	sta RESB
	lda #>($b400+8*32)
	sta RESB+1

	ldx #$02

	ldy #$00
@L1:
	lda (RES),y
	sta (RESB),y
	iny
	bne @L1
	inc RES+1
	inc RESB+1
	dex
	bne @L1
	rts
.endproc

.include "twi_display_signature.s"
.include "twi_print.s"
.include "twi_crlf.s"

.proc _wait
	ldy #$80
	ldx #0
@L1:
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
	bne @L1
	iny
	bne @L1
	rts
.endproc

.include "test_overlay_ram.s"

rom_signature:
	.byte "TWILIGHTE TEST ROM V0.1 BANK"

  .byte $30+ID_BANK

  .byte 0
            ;012345678901234567890
str_starting_test_bank_switching:
  .asciiz "STARTING TEST BANK SWITCHING"

_command1:
        rts

command1_str:
  .asciiz "twiltest"

commands_text:
        .addr command1_str
commands_address:
        .addr _command1
commands_version:
        .ASCIIZ "0.0.1"
parse_routine:
        ; A & Y contains the string to execute
        ; for example, if you want to execute the program hello in your rom :
        ; exec hello
        ; exec command will call your "parse_routine" with "hello" string pointer in A & Y 
        ; BUFEDT contains your command without exec word
        ; if you want to call any program in your rom, you can do :
        ; lda #<mystring_to_execute ; mystring_to_execute must be in ram because rom which contains the command needs to access  this string in order execute it
        ; lda #>mystring_to_execute
        ; BRK_ORIX($63)

        ; To test your command
        ; Type :
        ; exec mycommand
        rts



; ----------------------------------------------------------------------------
; Copyrights address

        .res $FFF1-*
        .org $FFF1
; $fff1
parse_vector:
        .addr parse_routine
; fff3
adress_commands:
        .addr commands_address
; fff5
list_commands:
        .addr rom_start
; $fff7
number_of_commands:
        .byt 1
signature_address:
        .word   rom_signature

; ----------------------------------------------------------------------------
; Version + ROM Type
ROMDEF:
    .addr rom_start

; ----------------------------------------------------------------------------
; RESET
rom_reset:
    .addr   rom_start
; ----------------------------------------------------------------------------
; IRQ Vector
empty_rom_irq_vector:
    .addr   IRQVECTOR ; from telestrat.inc (cc65)
end:






