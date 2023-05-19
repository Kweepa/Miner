booty
!byte 0

BootSquash

	lda #8
	sta 36879

	; clear the top part of the screen
	ldx #0
-	lda #0
	sta screen_base,x
	sta screen_base+118,x
	lda #1
	sta color_base,x
	sta color_base+118,x
	inx
	bne -

	; load up the plinth (udgs 1-4)
	ldx #31
-	lda plinth_graphic_data,x
	sta udg_base + 8,x
	dex
	bpl -

	;  and the boot (udgs 5-10)
	ldx #15
-	lda boot_graphic_data,x
	sta udg_base + 40,x
	lda boot_graphic_data+16,x
	sta udg_base + 64,x
	dex
	bpl -

	; load up willy (udgs 11-14)
	ldx #31
-	lda player_bmp + 64,x ; the mid step
	sta udg_base + 88,x
	dex
	bpl -

	; copy the boot cuff (udgs 15-16)
	lda boot_graphic_data
	sta udg_base + 120
	sta udg_base + 122
	sta udg_base + 124
	sta udg_base + 126
	lda boot_graphic_data+1
	sta udg_base + 121
	sta udg_base + 123
	sta udg_base + 125
	sta udg_base + 127
	lda boot_graphic_data+16
	sta udg_base + 128
	sta udg_base + 130
	sta udg_base + 132
	sta udg_base + 134
	lda boot_graphic_data+17
	sta udg_base + 129
	sta udg_base + 131
	sta udg_base + 133
	sta udg_base + 135

	; draw the plinth
	ldx #1
	stx screen_base + 22*15 + 10
	inx
	stx screen_base + 22*16 + 10
	inx
	stx screen_base + 22*15 + 11
	inx
	stx screen_base + 22*16 + 11

	; draw willy on the plinth
	ldx #11
	stx screen_base + 22*13 + 10
	inx
	stx screen_base + 22*14 + 10
	inx
	stx screen_base + 22*13 + 11
	inx
	stx screen_base + 22*14 + 11

	lda #240
	sta $900b

	; make the boot descend
descend
	lda #0
	sta booty
-
	dec $900b

	lda booty
	clc
	adc #2
	sta booty
	and #7
	bne +

	lda booty
	sec
	sbc #1
	lsr
	lsr
	lsr
	asl
	tay
	lda x22tab,y
	clc
	adc #10
	sta scr_ptr
	lda x22tab+1,y
	adc #>screen_base
	sta scr_ptr+1
	ldy #0
	lda #15
	sta (scr_ptr),y
	iny
	lda #16
	sta (scr_ptr),y

	ldy #22
	lda #5
	sta (scr_ptr),y
	iny
	lda #8
	sta (scr_ptr),y
	ldy #44
	lda #6
	sta (scr_ptr),y
	iny
	lda #9
	sta (scr_ptr),y

+
	jsr WaitForRaster

	lda booty
	cmp #(13*8)
	bne -

	lda #0
	sta $900b

	ldx #5
	ldy #9
	lda #STRINGGAME
	jsr PrintString

	ldx #13
	ldy #9
	lda #STRINGOVER
	jsr PrintString

wait_for_jump_press1x
    jsr GetJumpIsPressed
    bne wait_for_jump_press1x

wait_for_jump_pressx
    jsr GetJumpIsPressed
    beq wait_for_jump_pressx

wait_for_jump_press2x
    jsr GetJumpIsPressed
    bne wait_for_jump_press2x

	jsr UpdateHi

    rts
