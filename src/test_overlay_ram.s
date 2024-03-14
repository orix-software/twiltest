

.proc test_overlay_ram

  lda     #<_write_ram_overlay
  ldy     #>_write_ram_overlay

  jsr     _copy_code_512

  jsr     write_ram_overlay_in_ram

.endproc


.proc _write_ram_overlay
; this test is used for eeprom to SRAM switch
; Sram read crash

; Switch to bank $00
; write in ram overlay
  sei
  lda     #$00 ; Switch to overlay ram
  sta     $321
  ;jsr print_bank_code_in_ram
restart:
  ldx     #$00
incme:
  lda     $321
  and     #%00000111	; Get the current bank
  clc
  adc     #48
  sta     $bb80+13*40,x ; Store the current bank

  txa
  clc
  adc     #$41
  sta     $c000,x ; Write A or B ...


  lda     $321
  and     #%00000111
  clc
  adc     #48
  sta     $bb80+14*40+40,x ; Store the current bank after

  lda     $c000,x
  sta     $bb80+14*40,x


  lda     $bb80+14*40,x
  sec
  sbc     #$40
  sta     RES
  cpx     RES

  beq     error_sram



  inx
  cpx     #25
  bne     incme
  ;jsr _wait
  ;jsr _wait
  ;jsr _wait
  ;lda #$00
  ;beq restart

  lda #$07
  sta $321

  rts

error_sram:
   clc
   adc #$41
   sta $bb80+16*40,x
   lda #$15
   sta $bb80+501
   jmp error_sram

.endproc