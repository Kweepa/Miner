CopyDownGuardianBmp
	; A contains the index
	; guardian_bmps + 128*index
	sta arr+1
	lda #0
	lsr arr+1
	ror
	adc #<guardian_bmps
	sta arr
	lda arr+1
	adc #>guardian_bmps
	sta arr+1

	; copy down guardian bmp
	; 0 1 2 3 ..... 32 33 34 35 ...
	; 0 16 1 17 .... 32 48 33 49 ...
	
	ldy #127
	sty tmp
-	ldy tmp
	lda (arr),y
	pha
	tya
	and #$1f
	lsr
	bcc +
	ora #$10
+	sta ts
	tya
	and #$60
	ora ts
	tay
	pla
	sta (arr2),y
	dec tmp
	bpl -
	rts

CopyDownHorizontalGuardianBmp
	lda #<hguard_bmp
	sta arr2
	lda #>hguard_bmp
	sta arr2+1
	lda hguardian_index
	jmp CopyDownGuardianBmp

CopyDownVerticalGuardianBmp
	lda #<vguard_bmp
	sta arr2
	lda #>vguard_bmp
	sta arr2+1
	lda vguardian_index
	jmp CopyDownGuardianBmp

CopyAndFlipGuardian
	jsr CopyDownHorizontalGuardianBmp

	; flip sprites
	; 8x8 sprite arrangement before -> after
	; ACXXXXXX -> XXXXXXCA
	; BDXXXXXX -> XXXXXXDB (with bits reversed)
	; map left to right: keep bits 0-2 the same (within char block)
	; then %0000000<->%1110000, %0001000<->%1111000, %0010000<->%1100000, %0011000<->%1101000
	; i.e. bit 3 is the same
	; bits 4-6 are 7-x
	; bit 7 changes from 0-1

flippedbyte = ts
	ldx #127
--
	; calc destination byte

	; load the source and flip it
	lda hguard_bmp,x
	ldy #8
-	ror
	rol flippedbyte
	dey
	bne -
	txa
	eor #$f0 ; set bit 7, flip bits 4,5,6
	tay
	lda flippedbyte
	sta hguard_bmp,y
	dex
	bpl --
	rts

MulGuardianIndexBy7
    lda guardian_index
    asl
	asl
	asl
    sec
    sbc guardian_index
	clc
    adc #6
	rts

CopyDownGuardianData
	jsr MulGuardianIndexBy7
    tay
    ldx #6
-
    lda guardian_data,y
    sta hx,x
    dey
    dex
    bpl -
    rts

CopyUpGuardianData
	jsr MulGuardianIndexBy7
    tay
    ldx #6
-
    lda hx,x
    sta guardian_data,y
    dey
    dex
    bpl -
    rts

EraseBlock
	ldy erase_scr_off,x
	lda #0
	sta (scr_ptr),y
	lda #1
	sta (col_ptr),y
	dex
	bpl EraseBlock
	rts

erase_scr_off
	!byte 22,23,44,45,66,67

Erase2x2
	ldx #3
	jmp EraseBlock

EraseGuardians
    lda #0
    sta guardian_index
erase_guardian_loop
    jsr CopyDownGuardianData
    ldx hx
    ldy hy
    jsr ConvertXYToScreenAddr
	ldx #3
	lda ht
	and #16 ; horizontal?
	beq +
	lda hy	; vertical & y&7 == 0?
	and #7
	beq +
	inx
	inx
+
	jsr EraseBlock

    inc guardian_index
    lda guardian_index
    cmp num_guardians
    bne erase_guardian_loop
    rts

GetHorizontalGuardianBmpAddr
    lda hx
    and #$03
FinishHorizontalGuardianBmpAddr
    asl
    asl
    asl
    asl
    asl
    clc
    adc #<hguard_bmp
    sta arr
    lda #>hguard_bmp
    adc #0
    sta arr+1
    rts

AddBidirectionalGuardianBmpAddr
	clc
    lda hd
    and #$80
    adc arr
    sta arr
	lda arr+1
	adc #0
	sta arr+1
	rts

GetVerticalGuardianBmpAddr
    lda vguard_frame
	clc
	adc guardian_index
    and #$03
SkylabVerticalGuardianBmpAddrInterrupt
    asl
    asl
    asl
    asl
    asl
FinishVerticalGuardianBmpAddr
    clc
    adc #<vguard_bmp
    sta arr
    lda #>vguard_bmp
    adc #0
    sta arr+1
    rts

GetKongBeastBmpAddr
	lda frame_ctr
	and #$20
	sta tmp
	lda switch_count
	and #2
	asl
	asl
	asl
	asl
	asl
	clc
	adc tmp
	jmp FinishVerticalGuardianBmpAddr

GetSkylabBmpAddr
	ldx guardian_index
	lda skylab_frame,x
	jmp SkylabVerticalGuardianBmpAddrInterrupt

MoveHorizontalGuardian
    ; update x
    lda hx
    clc
    adc hd
    sta hx
    lda hd
    bmi +
    lda hx
    cmp hr
    bne +++
	beq ++
+
    lda hx
    cmp hl
    bne +++
++
	lda hd
	eor #$ff
	clc
	adc #1
    sta hd
+++
	rts

MoveVerticalGuardian
    ; update y
    lda hy
    clc
    adc hd
    sta hy
    lda hd
    bmi +
    lda hy
    cmp hr
    bne +++
	beq ++
+
    lda hy
    cmp hl
    bne +++
++
	lda hd
	eor #$ff
	clc
	adc #1
    sta hd
+++
	rts

draw_guardian_offsets
	!byte 22,23,44,45,66,67
draw_vguard_chrs
	!byte 0,3,1,4,2,5
draw_hguard_chrs
	!byte 0,2,1,3

DrawHorizontalGuardian
	inc hguard_count
    ; plaster to screen
    ldx hx
    ldy hy
    jsr ConvertXYToScreenAddr

	ldx #3
-
	ldy draw_guardian_offsets,x
	lda hc
	sta (col_ptr),y
	lda draw_hguard_chrs,x
	clc
	adc guard_udg_index
	sta (scr_ptr),y
	dex
	bpl -
	rts

DrawVerticalGuardian
	inc vguard_count
    ; plaster to screen
    ldx hx
    ldy hy
    jsr ConvertXYToScreenAddr

	ldx #3
	lda hy
	and #7
	beq +
	inx
	inx
+
-
	ldy draw_guardian_offsets,x
	lda hc
	sta (col_ptr),y
	lda draw_vguard_chrs,x
	clc
	adc guard_udg_index
	sta (scr_ptr),y
	dex
	bpl -
	rts

CalcGuardianUDGIndex
    lda guardian_index           ; x6
    asl
    clc
    adc guardian_index
    asl
    sta guard_udg_off
    clc
    adc #GUARDIAN_CHR
	sta guard_udg_index

	rts

CalcGuardianUDGAddr
	; arr2 ends up with the udg address

	lda guard_udg_off
    asl
    asl
    asl                 ; x8
    adc #<guardian_udgs
    sta arr2
    lda #>guardian_udgs
    adc #0
    sta arr2+1
	rts

CopyHorizontalGuardianFrame
    ldy #31
-   lda (arr),y
    sta (arr2),y
    dey
    bpl -
	rts

CopyVerticalGuardianFrame
	lda arr2
	clc
	adc #24
	sta arr3
	lda arr2+1
	adc #0
	sta arr3+1
	lda arr
	sta mod_src_col1+1
	clc
	adc #16
	sta mod_src_col2+1
	lda arr+1
	sta mod_src_col1+2
	sta mod_src_col2+2

	; clear the top section
	ldy #0

	lda hy
	and #7
	beq +
	tax

	lda #0
-
	sta (arr2),y
	sta (arr3),y
	iny
	dex
	bne -
+
	; copy the center section
	ldx #16
-
mod_src_col1
	lda vguard_bmp
	inc mod_src_col1+1
	sta (arr2),y
mod_src_col2
	lda vguard_bmp
	inc mod_src_col2+1
	sta (arr3),y
	iny
	dex
	bne -

	; clear the bottom section
	lda hy
	and #7
	eor #7
	tax

	lda #0
-
	sta (arr2),y
	sta (arr3),y
	iny
	dex
	bpl -

	rts

MoveGuardians
    lda #0
    sta guardian_index
	sta hguard_count
	sta vguard_count
-
	jsr CalcGuardianUDGIndex
    jsr CopyDownGuardianData
	lda ht
	beq MoveBidirectionalHorizontalGuardian
	cmp #GUARDIAN_UNIDIRECTIONALHORIZONTAL
	beq MoveUnidirectionalHorizontalGuardian
	cmp #GUARDIAN_EUGENE
	beq MoveEugene
	cmp #GUARDIAN_VERTICAL
	beq MoveNormalVerticalGuardian
	cmp #GUARDIAN_KONG
	beq MoveKongBeast
	cmp #GUARDIAN_SKYLAB
	beq MoveSkylab

EndGuardianLoop
    jsr CopyUpGuardianData
    inc guardian_index
    lda guardian_index
    cmp num_guardians
    bne -
	lda remove_guardian
	beq +
	dec remove_guardian
	dec num_guardians
	inc kong_dead
+
    rts

MoveBidirectionalHorizontalGuardian
	jsr ShouldMoveHorizontalGuardianThisFrame
	bne +
	jsr MoveHorizontalGuardian
    jsr GetHorizontalGuardianBmpAddr
	jsr AddBidirectionalGuardianBmpAddr
ContinueMoveHorizontalGuardian
	jsr CalcGuardianUDGAddr
    jsr CopyHorizontalGuardianFrame
+
EndMoveHorizontalGuardian
	jsr DrawHorizontalGuardian
	jmp EndGuardianLoop

MoveUnidirectionalHorizontalGuardian
	jsr ShouldMoveHorizontalGuardianThisFrame
	bne EndMoveHorizontalGuardian
	jsr MoveHorizontalGuardian
    jsr GetHorizontalGuardianBmpAddr
	jmp ContinueMoveHorizontalGuardian

MoveEugene
	jsr ShouldMoveVerticalGuardianThisFrame
	bne +++
	jsr UpdateEugene
	jsr CalcGuardianUDGAddr
	jsr CopyVerticalGuardianFrame
+++
	jsr DrawVerticalGuardian
	jmp EndGuardianLoop

MoveNormalVerticalGuardian
	jsr ShouldMoveVerticalGuardianThisFrame
	bne +
	jsr MoveVerticalGuardian ; needs to fall when all keys collected
	jsr GetVerticalGuardianBmpAddr
	jsr CalcGuardianUDGAddr
	jsr CopyVerticalGuardianFrame
+
	jsr DrawVerticalGuardian
	jmp EndGuardianLoop

MoveKongBeast
	; fall when both switches pulled
	jsr UpdateKongBeast
	jsr GetKongBeastBmpAddr
	jsr CalcGuardianUDGAddr
	jsr CopyVerticalGuardianFrame
	jsr DrawVerticalGuardian
	jmp EndGuardianLoop

MoveSkylab
	jsr ShouldMoveVerticalGuardianThisFrame
	bne skylab_finish
	lda hy
	and #7
	bne skylab_fall
	; check under to see if crashing
	lda hy
	lsr
	lsr
	clc
	adc #4
	tay
	lda x22tab,y
	adc #<map_base
	sta arr
	lda #>map_base
	adc x22tab+1,y
	sta arr+1
	lda hx
	lsr
	lsr
	adc arr
	sta arr
	lda arr+1
	adc #0
	sta arr+1
	ldy #0
	lda (arr),y
	cmp #PLATFORM
	beq skylab_crashing
	cmp #BELT
	beq skylab_crashing
	bne skylab_fall

skylab_crashing
	ldx guardian_index
	inc skylab_frame,x
	lda skylab_frame,x
	cmp #8
	bne skylab_animate

	; move to the next column
	lda hx
	lsr
	lsr
	lsr
	tax
	lda skylab_nextx,x
	sta hx
	; move to the top of the screen
	lda #8
	sta hy
	; reset the animation frame
	lda #0
	ldx guardian_index
	sta skylab_frame,x

	jmp skylab_animate

skylab_fall
	; falling
	lda hy
	clc
	adc hd
	sta hy
	ldx guardian_index
skylab_animate
	jsr GetSkylabBmpAddr
	jsr CalcGuardianUDGAddr
	jsr CopyVerticalGuardianFrame

skylab_finish
	jsr DrawVerticalGuardian
	jmp EndGuardianLoop

UpdateEugene
	 ; needs to fall when all keys collected
    lda key_count
    bne +
	lda hy
	cmp #112
	beq ++
	inc hy
	bne ++
+
	jsr MoveVerticalGuardian
++
	; arr = frame1 (no animation)
    lda #<vguard_bmp
    sta arr
    lda #>vguard_bmp
    sta arr+1
	rts

UpdateKongBeast
	lda #0
	sta kong_dead
	lda switch_count
	cmp #2
	bne ++
	jsr ShouldMoveVerticalGuardianThisFrame
	bne ++
	lda hy
	cmp #112
	beq +
	inc hy
	inc hy
	jsr MoveVerticalGuardian
	jmp ++
+
	inc remove_guardian
++
	rts

ShouldMoveHorizontalGuardianThisFrame
	lda hguard_count
	and #3
	cmp left_right_ctr
	rts

ShouldMoveVerticalGuardianThisFrame
	; bne + after this function to not move
	lda vguard_count
	cmp up_down_ctr
	beq +
	sec
	sbc #3
	cmp up_down_ctr
+
	rts

skylab_nextx ; indexed by current column (0-10)
	!byte 24,32,48,56,64,0,72,80,8,16,0