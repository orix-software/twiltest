.proc twi_crlf

    inc     posy

    ldx     posy
    lda     TABLE_LOW_TEXT,x
    sta     ADDR_SCREEN
    lda     TABLE_HIGH_TEXT,x
    sta     ADDR_SCREEN+1
    rts
.endproc