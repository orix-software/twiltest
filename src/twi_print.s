.proc twi_print

    sta     PTR_STRING
    sty     PTR_STRING+1

    ldy     #$00
@L1:
    lda     (PTR_STRING),y
    beq     @out
    cmp     #$0D
    bne     @not_eol

    jsr     twi_crlf

    jmp     @next_char

@not_eol:
    sta     (ADDR_SCREEN),y
@next_char:
    iny
    jmp     @L1
@out:
    tya
    clc
    adc     ADDR_SCREEN
    bcc     @no_inc
    inc     ADDR_SCREEN+1
@no_inc:
    sta     ADDR_SCREEN
    rts
.endproc

TABLE_LOW_TEXT:
;0
    .byt <($bb80)
    .byt <($bb80+40)
    .byt <($bb80+80)
    .byt <($bb80+120)
    .byt <($bb80+160)
    .byt <($bb80+200)
    .byt <($bb80+240)
    .byt <($bb80+280)
    .byt <($bb80+320)
    .byt <($bb80+360)
    .byt <($bb80+400)
    .byt <($bb80+440)
    .byt <($bb80+480)
    .byt <($bb80+520)
    .byt <($bb80+560)
    .byt <($bb80+600)
    .byt <($bb80+640)
    .byt <($bb80+680)
    .byt <($bb80+720)
    .byt <($bb80+760)
    .byt <($bb80+800)
    .byt <($bb80+840)
    .byt <($bb80+880)
    .byt <($bb80+920)
    .byt <($bb80+960)
    .byt <($bb80+1000)
    .byt <($bb80+1040)
    .byt <($bb80+1080)


TABLE_HIGH_TEXT:
    .byt >($bb80)
    .byt >($bb80+40)
    .byt >($bb80+80)
    .byt >($bb80+120)
    .byt >($bb80+160)
    ;5
    .byt >($bb80+200)
    .byt >($bb80+240)
    .byt >($bb80+280)
    .byt >($bb80+320)
    .byt >($bb80+360)
    ;10
    .byt >($bb80+400)
    .byt >($bb80+440)
    .byt >($bb80+480)
    .byt >($bb80+520)
    .byt >($bb80+560)
    ;15
    .byt >($bb80+600)
    .byt >($bb80+640)
    .byt >($bb80+680)
    .byt >($bb80+720)
    .byt >($bb80+760)
    ;20
    .byt >($bb80+800)
    .byt >($bb80+840)
    .byt >($bb80+880)
    .byt >($bb80+920)
    .byt >($bb80+960)
    ;25
    .byt >($bb80+1000)
    ; 26
    .byt >($bb80+1040)
    ; 27
    .byt >($bb80+1080)

