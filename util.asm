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
    bcs WaitForRasterLineLessThan
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
    lda #4
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

	jmp DisplayScore

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
	jmp DisplayScore

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
	beq +
	bcc do_update_hi
+
	lda score+1
	sec
	sbc hi+1
	beq +
	bcs do_update_hi
+
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
	jsr InitMusic
	ldx air
	beq +
-	jsr Add10ToScore
	dec air
	lda air
	lsr
	clc
	adc #127
	sta $900b
	jsr DrawAir
	jsr WaitForRaster
	lda air
	bpl -
+
	rts

AddExtraMan
	lda map
	cmp #5
	beq ++
	cmp #10
	beq ++
	cmp #15
	beq ++
	cmp #20
	beq +
	rts
+
	jsr EndGame
++
	inc men
	rts

EndGame
	; move the player to the upper section
	jsr ErasePlayer
	lda #(12*4+2)
	sta px
	lda #(2*8)
	sta py

	; clear the spot for the player
	lda #1
	sta color_base+22*2+12
	sta color_base+22*2+13
	sta color_base+22*3+12
	sta color_base+22*3+13
	lda #0
	sta screen_base+22*2+12
	sta screen_base+22*2+13
	sta screen_base+22*3+12
	sta screen_base+22*3+13

	jsr DrawPlayer

	; draw sword and fish
	lda #156
	sta screen_base+22*5+12
	lda #157
	sta screen_base+22*5+13
	lda #158
	sta screen_base+22*6+12
	lda #159
	sta screen_base+22*6+13
	lda #CYAN
	sta color_base+22*5+12
	sta color_base+22*5+13
	lda #YELLOW
	sta color_base+22*6+12
	lda #WHITE
	sta color_base+22*6+13

	jsr InitMusic

	dec map

	; make success noise
	ldx #11
--
	ldy #144
-
	sty $900b
	jsr FinalBarrierUpperSettings
	jsr FinalBarrierLowerSettings
	jsr WaitForRasterLine
	jsr WaitForRasterLineLessThan
	iny
	cpy #168
	bne -
	dex
	bne --

	lda #0
	sta map

	rts

FinalBarrierUpperSettings
	lda map
	cmp #19
	bne +
	lda #58
	sta $900f
+
	rts

FinalBarrierLowerSettings
	lda map
	cmp #19
	bne +

-
	lda $9004
    and #$fe
    cmp #57 ; rasterline
    bcs -
-
	lda $9004
    and #$fe
    cmp #57 ; rasterline
    bcc -
	lda #10
	sta $900f
+

	rts
