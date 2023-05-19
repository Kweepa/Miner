;
; WaitForRasterLine
;

WaitForRasterLine
    lda $9004
    and #$fe
    cmp #RASTERLINE_PAL ; rasterline
    bne WaitForRasterLine
    rts

;
; WaitForRasterLineLessThan
;

WaitForRasterLineLessThan
    lda $9004
    and #$fe
    cmp #RASTERLINE_PAL ; rasterline
    bpl WaitForRasterLineLessThan
    rts

WaitForRaster
	jsr WaitForRasterLineLessThan
	jmp WaitForRasterLine

ClearScreen
    ldx #0
-
    lda #0
    sta screen_base,x
    sta screen_base + $100,x
    sta map_base,x
    sta map_base + $100,x
    lda #1
    sta color_base,x
    sta color_base + $100,x
    dex
    bne -
    rts

x22tab
!word 0,22,44,66,88,110,132,154,176,198,220,242,264,286,308,330,352,374,396,418,440,462

ConvertXYToScreenAddr
    tya
    sec
    sbc #8
    lsr
    lsr
    and #$fe
    tay
    lda x22tab,y
    sta tmp
    txa
    lsr
    lsr
    clc
    adc tmp
    sta scr_ptr
    sta map_ptr
    sta col_ptr
    lda x22tab + 1,y
    adc #>screen_base
    sta scr_ptr + 1
    adc #((>map_base) - (>screen_base))
    sta map_ptr + 1
    adc #((>color_base) - (>map_base))
    sta col_ptr + 1
    rts

PrintString
    pha
	stx tmp
	tya
	asl
	tay
	lda x22tab,y
	clc
	adc tmp
	sta scr_ptr
	sta col_ptr
	lda #>screen_base
	adc x22tab+1,y
	sta scr_ptr+1
	clc
	adc #((>color_base) - (>screen_base))
	sta col_ptr+1

    pla
    tay
    lda strings_lo,y
    sta arr
    lda strings_hi,y
    sta arr+1
    ldy #0
    lda (arr),y
    iny
    sta tmp

-
    lda (arr),y
    beq +++
	dey

	jsr ConvertCharToFontChar
	clc
	adc #((fontchars - udg_base)/8)

    sta (scr_ptr),y
    lda tmp
    sta (col_ptr),y
++
    iny
	iny
    bpl -

+++
    rts

UpdateMoveCounters
    dec left_right_ctr
    bpl +
    lda #3
    sta left_right_ctr
	inc hguard_frame
+
    dec crumble_ctr
    bpl +
    lda #6
    sta crumble_ctr
+
	dec up_down_ctr
	bpl +
	lda #2
	sta up_down_ctr
	inc vguard_frame
+
	inc frame_ctr
    rts

Add100ToScore
	sed
	lda score+1
	clc
	adc #1
	sta score+1
	lda score+2
	adc #0
	sta score+2
	cld

	jsr DisplayScore
	jmp UpdateHi

Add10ToScore
	sed
	lda score
	clc
	adc #10
	sta score
	lda score+1
	adc #0
	sta score+1
	lda score+2
	adc #0
	sta score+2
	cld
	jsr DisplayScore
	jmp UpdateHi

DisplayScoreDigitPair
	tay
	and #$f
	clc
	adc #212
	sta screen_base+22*20,x
	dex
	tya
	lsr
	lsr
	lsr
	lsr
	clc
	adc #212
	sta screen_base+22*20,x
	dex
	rts

DisplayScore
	ldx #21
	lda score
	jsr DisplayScoreDigitPair
	lda score+1
	jsr DisplayScoreDigitPair
	lda score+2
	jsr DisplayScoreDigitPair
	rts

DisplayHi
	ldx #8
	lda hi
	jsr DisplayScoreDigitPair
	lda hi+1
	jsr DisplayScoreDigitPair
	lda hi+2
	jsr DisplayScoreDigitPair
	rts

UpdateHi
	lda score+2
	sec
	sbc hi+2
	beq ++
	bcc do_update_hi

++
	lda score+1
	sec
	sbc hi+1
	beq ++
	bcs do_update_hi

++
	lda score
	sec
	sbc hi
	bcs do_update_hi
	rts

do_update_hi
	lda score
	sta hi
	lda score+1
	sta hi+1
	lda score+2
	sta hi+2
	jmp DisplayHi

RunOutAir
	ldx air
	beq +
-	jsr Add10ToScore
	dec air
	jsr DrawAir
	jsr WaitForRaster
	dex
	bpl -
+
	rts