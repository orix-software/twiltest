.proc twi_display_signature

  ldy     #$00
@L1:
  lda     rom_signature,y
  beq     @out
  sta     (ADDR_SCREEN),y
  iny
  jmp     @L1
@out:
  rts
.endproc
