ResetGame
    lda #0
    sta map

	lda #0
	sta score
	sta score+1
	sta score+2

    lda #3
    sta men
	rts

ResetMap
    lda #1
    ldx #10
key_reset_loop
    sta key_cols-1,x
    dex
    bne key_reset_loop

    lda #0
    sta hit_exit
    sta left_right_ctr
    sta crumble_ctr
	sta up_down_ctr

	rts

DrawMap
    jsr ClearScreen

	ldx #0
	ldy #18
	lda #STRINGAIR
	jsr PrintString

	ldx #0
	ldy #20
	lda #STRINGHI
	jsr PrintString

	jsr DisplayHi

	ldx #10
	ldy #20
	lda #STRINGSCORE
	jsr PrintString

	jsr DisplayScore

	lda #(17*8)
	sta air
	lda #1
	sta air_ctr

	ldx #16
	lda #SOLID_CHR
-	sta screen_base + 22*18 + 4,x
	dex
	bpl -

    lda #0
    sta dead
	sta xadd
    sta key_count
	sta switch_count
	sta remove_guardian
	lda #0
	sta skylab_frame
	sta skylab_frame+1
	sta skylab_frame+2
	lda #1
	sta kong_dead

    lda #27
    sta inairtime

    lda map
    asl
    tax
    lda maptab,x
    sta arr
    lda maptab+1,x
    sta arr+1

    ldx men
    dex
	jmp +
draw_men_loop
    lda #HEAD_CHR
    sta screen_base + $1e4,x
    lda #3
    sta color_base + $1e4,x
+
    dex
    bpl draw_men_loop

; load type count
    ldy #0
    lda (arr),y
    iny
    sta tmp

loop

; load type
    lda (arr),y
    iny
    sta typ
; load col
    lda (arr),y
    iny
    sta col
; load num of this type
    lda (arr),y
    and #$7f
    tax
    lda (arr),y
    iny
    and #$80
    sta ts

type_loop

; load lo byte of address
    lda (arr),y
    iny
    sta scr_ptr
    sta col_ptr
    sta map_ptr

; load hi byte of address (+run count)
    lda (arr),y
    iny
    pha
    and #$01
    ora #>screen_base
    sta scr_ptr + 1
    clc
    adc #((>map_base) - (>screen_base))
    sta map_ptr + 1
    adc #((>color_base) - (>map_base))
    sta col_ptr + 1

    ; pull run
    pla
    lsr
    sta run
    inc run

    tya
    pha

    ldy #0

run_loop

    lda typ
    cmp #KEY
    bne not_a_key
	inc key_count

    txa
    pha
    asl
    tax
    lda col_ptr
    sta key_cols-2,x
    lda col_ptr+1
    sta key_cols-1,x
	lda scr_ptr
	sta key_adds-2,x
	lda scr_ptr+1
	sta key_adds-1,x
    pla
    tax

not_a_key
    lda col
    sta (col_ptr),y
    lda typ
    sta (scr_ptr),y
    sta (map_ptr),y

    iny
    lda ts
    bpl skip_add_21
    tya
    clc
    adc #21
    tay
skip_add_21
    dec run
    bne run_loop

    pla
    tay

    dex
    bne type_loop
    dec tmp
    beq map_draw_done
    jmp loop
map_draw_done

	lda (arr),y
	iny
	sta exit_col
	lda (arr),y
	iny
	sta exitx
	lda (arr),y
	iny
	sta exity

	; copy exit graphics
	ldx #0
-
	txa
	pha

	and #$1f
	lsr
	bcc +
	ora #$10
+	sta ts
	txa
	and #$60
	ora ts
	tax

	lda (arr),y
	iny

	sta exit_udgs,x

	pla
	tax
	inx
	cpx #32
	bne -

	; read block indices
	jsr CopyBlockBmps
    
    lda (arr),y
    iny
    sta num_guardians ; x7
	asl
    asl
    asl
    sec
    sbc num_guardians
    sta tmp

	; copy all guardian data
	ldx #0
-   lda (arr),y
    iny
    sta guardian_data,x
    inx
	cpx tmp
    bne -

    lda (arr),y
    iny
    sta 36879

	; fill the top row with solid blocks
    ldx #21
-
    lda #SOLID_CHR
    sta screen_base,x
    lda 36879
	and #7
    sta color_base,x
    dex
    bpl -


    lda (arr),y
    iny
    sta px
	
	lda (arr),y
	iny
	sta py

    lda (arr),y
    iny
    sta belt_spd

	; read guardian indices

	lda (arr),y
	iny
	sta hguardian_index

	lda (arr),y
	iny
	sta vguardian_index

    jsr PrintSpecFontString

	jsr CopyAndFlipGuardian
	jsr CopyDownVerticalGuardianBmp

    jsr DrawPlayer

	jsr ResetLightBeam

	jsr DrawFinalBackground

; uncomment this to test the map drawing without continuing
;-	jmp -
    rts

FlickerKeys
    ldx #0
flicker_key_loop
    lda key_cols+1,x
    beq dont_flicker_this_key
	cmp #1
	beq dont_flicker_this_key
    lda (key_cols,x)
    clc
    adc #1
    and #7
    sta (key_cols,x)
	lda #KEY
	sta (key_adds,x)
dont_flicker_this_key
    inx
    inx
    cpx #10
    bne flicker_key_loop
    rts

DrawExit
	lda exity
	asl
	tay
	lda x22tab,y
	clc
	adc exitx
	sta scr_ptr
	sta col_ptr
	lda #>screen_base
	adc x22tab+1,y
	sta scr_ptr+1
    adc #((>color_base) - (>screen_base))
    sta col_ptr+1

	ldy #0
	lda #EXIT
	sta (scr_ptr),y
	iny
	lda #(EXIT+2)
	sta (scr_ptr),y
	ldy #22
	lda #(EXIT+1)
	sta (scr_ptr),y
	iny
	lda #(EXIT+3)
	sta (scr_ptr),y

    lda key_count
    bne +
	lda kong_dead
	beq +
	lda exit_col
    eor #$07 ; flash exit
	sta exit_col

	; check for player hitting exit (only when flashing)
	ldx exitx
	inx
	txa
	asl
	asl
	sec
	sbc px
	bmi +
	cmp #3
	bcs +
	ldx exity
	inx
	txa
	asl
	asl
	asl
	sec
	sbc py
	bmi +
	cmp #15
	bcs +
	lda #1
	sta hit_exit

+
    lda exit_col
    ldy #0
    sta (col_ptr),y
    iny
    sta (col_ptr),y
    ldy #22
    sta (col_ptr),y
    iny
    sta (col_ptr),y

    rts

CopyBlockBmps
	ldx #0
--
	lda #0
	sta arr2+1
	lda (arr),y
	iny
	asl
	rol arr2+1
	asl
	rol arr2+1
	asl
	rol arr2+1
	adc #<block_bmps
	sta arr2
	lda arr2+1
	adc #>block_bmps
	sta arr2+1

	tya
	pha

	ldy #0
-
	lda (arr2),y
	sta udg_base+8,x
	inx
	iny
	cpy #8
	bne -

	pla
	tay

	cpx #64
	bne --

	; shift down the crumbling blocks (9-15 copied from 8)
	ldx #0
-
	lda udg_base+8*8,x
	sta udg_base+8*8+9,x
	inx
	cpx #55
	bne -
	; fill the beginnings with 0
	ldx #0
-	txa
	and #7
	sta tmp
	txa
	lsr
	lsr
	lsr
	cmp tmp
	bcc +
	lda #0
	sta udg_base+9*8,x
+	inx
	cpx #56
	bne -

	; get the switch gfx
	jsr GetNextGraphicAddr

	tya
	pha

	; copy over the switch (and flip it)
	ldy #7
--	lda (arr2),y
	sta udg_base+8*SWITCH_CHR,y
	ldx #8
-	asl
	ror tmp
	dex
	bne -
	lda tmp
	sta udg_base+8*SWITCHED_CHR,y
	dey
	bpl --

	pla
	tay

	; get the block2 gfx
	jsr GetNextGraphicAddr

	tya
	pha

	; copy over the block
	ldy #7
--	lda (arr2),y
	sta udg_base+8*BLOCK2_CHR,y
	dey
	bpl --

	pla
	tay

	; get the platform2 gfx
	jsr GetNextGraphicAddr

	tya
	pha

	; copy over the platform2 udg
	ldy #7
--	lda (arr2),y
	sta udg_base+8*PLATFORM2_CHR,y
	dey
	bpl --

	pla
	tay

	; and fill 0, 62 & 63 (solid block & head)
	ldx #8
-	lda #255
	sta udg_base+SOLID_CHR*8-1,x
	lda player_bmp-1,x
	sta udg_base+HEAD_CHR*8-1,x
	lda #0
	sta udg_base-1,x
	dex
	bne -

	rts

GetNextGraphicAddr
	lda #0
	sta arr2+1
	lda (arr),y
	iny
	asl
	rol arr2+1
	asl
	rol arr2+1
	asl
	rol arr2+1
	adc #<block_bmps
	sta arr2
	lda arr2+1
	adc #>block_bmps
	sta arr2+1
	rts

AnimateBelts
    lda left_right_ctr
    bne no_belt_animate
    lda belt_spd
    bpl belt_animate_right
    lda udg_base + 40
    asl
    rol udg_base + 40
    lda udg_base + 42
    lsr
    ror udg_base + 42
    rts
belt_animate_right
    lda udg_base + 40
    lsr
    ror udg_base + 40
    lda udg_base + 42
    asl
    rol udg_base + 42
no_belt_animate
    rts

UpdateAir
	dec air_ctr
	bne ++
	lda #60
	sta air_ctr
	dec air
	bne +
	lda #1
	sta dead
	rts
+
DrawAir
	; draw
	lda air
	lsr
	lsr
	lsr
	tax
	lda air
	and #7
	tay
	lda color_fade,y
	sta color_base + 22*18 + 4,x
++
	rts

color_fade
	!byte BLACK, BLUE, RED, PURPLE, GREEN, CYAN, YELLOW, WHITE
