try_touch
    lda (map_ptr),y
    sta typ
    cmp #KEY
    beq get_key
    cmp #BLOCK
    beq do_block
	cmp #BLOCK2
	beq do_block
	cmp #SWITCH
	beq throw_switch
    lda #0
    rts
do_block
    lda #1
    rts

throw_switch
	inc switch_count
	lda #SWITCHED_CHR
	sta (scr_ptr),y
	sta (map_ptr),y

	lda switch_count
	cmp #1
	bne +
	; first switch...
	; open up the passage, and let the dude wander through
	lda #0
	sta screen_base+22*11+12
	sta screen_base+22*12+12
	sta screen_base+22*13+12
	sta map_base+22*11+12
	sta map_base+22*12+12
	sta map_base+22*13+12
	lda #1
	sta color_base+22*12+12
	sta color_base+22*12+12
	sta color_base+22*13+12
	lda #55
	sta guardian_data+7+3 ; extend hr for 2nd guardian
	bne ++
+
	; second switch
	; delete the floor under kong
	lda #0
	sta screen_base+22*3+10
	sta screen_base+22*3+11
	sta map_base+22*3+10
	sta map_base+22*3+11
	lda #1
	sta color_base+22*3+10
	sta color_base+22*3+11
++
	lda #0
	rts

get_key
    dec key_count
    lda #1
    sta (col_ptr),y
    lda #0
    sta (map_ptr),y
    sta (scr_ptr),y

    sty tmp

	; tramples on A,X,Y
	jsr Add100ToScore

	ldy tmp

    lda col_ptr
    clc
    adc tmp
    sta arr
    lda col_ptr+1
    adc #0
    sta arr+1
    ldx #0
get_key_loop
    lda key_cols,x
    cmp arr
    bne not_this_key
    lda key_cols+1,x
    cmp arr+1
    bne not_this_key
    lda #1
    sta (col_ptr),y
    lda #0
    sta (map_ptr),y
    sta (scr_ptr),y
    sta key_cols+1,x
    beq get_key_done
not_this_key
    inx
    inx
    cpx #10
    bne get_key_loop
get_key_done
    ; return 0 (no block)
    lda #0
    rts

try_touch_below
    lda (map_ptr),y
    sta typ
    cmp #KEY
    beq get_key
    cmp #BELT
    bcs do_block_below ; if A >= BELT
    lda #0
    rts

do_block_below
    cmp #BELT
    bne +
    lda belt_spd
    sta xadd
	sta lastxmove
    bne ++
+
    lda #0
    sta xadd
++
    lda #1
    rts

try_crumble
    lda crumble_ctr
    bne +
    lda (map_ptr),y
    cmp #CRUMBLE
    bcc +
	cmp #(CRUMBLE+8)
	bcs +
    clc
    adc #1
    and #$0f
    sta (map_ptr),y
    sta (scr_ptr),y
    bne +
    lda #1
    sta (col_ptr),y
+
	rts

CollideLeftRight
; collide left/right?
    lda left_right_ctr
    bne end_collide_left_right
    lda xadd
    bpl collide_right
    lda px
    beq end_collide_left_right ; px=0, don't move left
    lda px
    and #$03
    bne move_left
; look at bytes to left
    ldy #21
    jsr try_touch
    bne end_collide_left_right
    ldy #43
    jsr try_touch
    bne end_collide_left_right
    lda py
    and #$07
    beq move_left
    ldy #65
    jsr try_touch
    bne end_collide_left_right
move_left
    dec px
    ldx px
    ldy py
    jsr ConvertXYToScreenAddr
    jmp end_collide_left_right

collide_right
    lda xadd
    beq end_collide_left_right
    lda px
    cmp #84
    beq end_collide_left_right
    lda px
    and #$03
    bne move_right
; look at bytes to the right
    ldy #23
    jsr try_touch
    bne end_collide_left_right
    ldy #45
    jsr try_touch
    bne end_collide_left_right
    lda py
    and #$07
    beq move_right
    ldy #67
    jsr try_touch
    bne end_collide_left_right
move_right
    inc px
    ldx px
    ldy py
    jsr ConvertXYToScreenAddr
end_collide_left_right
    rts

Collide

	; reset sound effect
	lda #0
	sta $900c
	lda on_ground
	bne +
	lda inairtime
	lsr
	tax
	lda jumpnotes,x
	sta $900c
+

    lda on_ground
    sta was_on_ground
    inc inairtime
    lda inairtime
    cmp #52
    bne +
    lda #0
    sta xadd
+
    lda #0
    sta on_ground
    sta mov
    ldx px
    ldy py
    jsr ConvertXYToScreenAddr

    jsr CollideLeftRight

    lda py
    and #$f8
    sta tmp
	lda inairtime
	cmp #51
	bcc +
	lda #51
+
    tax
    lda jumptab,x
    clc
    adc py
    sta newy
    lda inairtime
    cmp #27
    bcs collide_down
    lda newy
    and #$f8
    cmp tmp
    beq move_up_down
; look at bytes above
    ldy #0
    jsr try_touch
    bne hit_above
    lda px
    and #$03
    beq move_up_down
    ldy #1
    jsr try_touch
    bne hit_above
    beq move_up_down    
collide_down
    lda py
    and #$07
    beq look_below_2
; look below 3
    lda newy
    and #$f8
    cmp tmp
    beq move_up_down
    ldy #88
    jsr try_touch_below
    bne hit_below
    lda px
    and #$03
    beq move_up_down
    iny
    jsr try_touch_below
    bne hit_below
    beq move_up_down
look_below_2
    lda was_on_ground
    beq +
    lda #0	; possibly falling off ledge, so zero out x velocity
    sta xadd
+
    ldy #66
	jsr try_crumble
	lda px
	and #$03
	beq +
	iny
	jsr try_crumble
	dey
+
    jsr try_touch_below
	bne check_jump
    lda px
    and #$03
    beq move_up_down
    iny
    jsr try_touch_below
    beq move_up_down
check_jump
    lda #1
    sta on_ground
    lda #27
    sta inairtime
    lda jumpIsPressed
    beq collide_end
    lda #0
    sta inairtime
    jmp collide_end
move_up_down
    lda #1
    sta mov
collide_done
collide_end
    lda mov
    beq collide_dont_move_y
    lda newy
    sta py
collide_dont_move_y
    jsr DrawPlayer
    rts
hit_above
    lda #27
    sta inairtime
    lda py
    and #$f8
    sta newy
    jmp move_up_down
hit_below
	jsr CheckDeathFall
    lda #27
    sta inairtime
    lda newy
    and #$f8
    sta newy
    jmp move_up_down

CheckDeathFall
	lda inairtime
	cmp #70
	bcc +
	lda #1
	sta dead
+
	rts

jumptab ; 54 bytes
!byte -2, -1, -2, -1, -2, -1, -1, -1, -2, -1, -1, 0, -1, -1, -1, 0, -1, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0
!byte 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 2, 1, 1, 1, 2, 1, 2, 1, 2

jumpnotes ; 27 bytes
!byte 150,155,160,165,170,175,180,185,190
!byte 195,200,205,210,215,210,205,200,195
!byte 190,185,180,175,170,165,160,155,150

TryTouchLightBeam
	lda frame_ctr
	and #15
	beq +
	rts
	ldx #3
	lda py
	and #7
	beq +
	ldx #5
+
-
	ldy erase_scr_off,x
	lda (map_ptr),y
	and #7
	cmp #YELLOW
	beq touched_light_beam
	dex
	bpl -
	rts
touched_light_beam
	dec air
	jsr DrawAir
	lda air
	bne +
	lda #1
	sta dead
+
	rts

ErasePlayer
    ldx px
    ldy py
    jsr ConvertXYToScreenAddr
	lda map
	cmp #18
	bne +
	jsr TryTouchLightBeam
+
	ldx #5
-
	ldy erase_scr_off,x
	lda (map_ptr),y
	sta (scr_ptr),y
	dex
	bpl -

    rts

setudgadd
	; takes Y
	; modifies and requires X
	lda #0
	sta tmp
    lda (scr_ptr),y
	sta player_overlap,x
	inx
    asl
    asl
	rol tmp
    asl
	rol tmp
    sta udg_ptr
    lda #>udg_base
	adc tmp
    sta udg_ptr+1
    rts

copy_udg
    ldy #7
-
    lda (udg_ptr),y
    sta (play_udg),y
    dey
    bpl -
    rts

draw_player_offsets
	!byte 22,44,66,23,45,67
draw_player_chrs
	!byte PLAY_CHR, PLAY_CHR+1, PLAY_CHR+2, PLAY_CHR+3, PLAY_CHR+4, PLAY_CHR+5

DrawPlayer
	; clear overlaps/touches
	ldx #(48+6-1)
	lda #0
-
	sta player_overlap,x
	dex
	bpl -

    ; first read screen bitmaps to player bitmaps
    ldx px
    ldy py
    jsr ConvertXYToScreenAddr
    lda #<player_udg
    sta play_udg
    lda #>player_udg
    sta play_udg+1

	ldx #0
-
    ldy draw_player_offsets,x
    jsr setudgadd
    jsr copy_udg

    lda play_udg
    clc
    adc #8
    sta play_udg

	cpx #6
	bne -

    ; now or player bitmaps to player udg 3x2
    lda py
    and #$07
    sta tmp
    tax

    lda px
    and #$03
    asl
    asl
    asl
    asl
    asl
    clc
    adc #<player_bmp
    sta arr
	lda #>player_bmp
	adc #0
	sta arr+1
    lda lastxmove
    and #$80
    adc arr
    sta arr
    lda arr+1
    adc #0
    sta arr+1
    lda arr
    clc
    adc #16
    sta arr2
    lda arr+1
    adc #0
    sta arr2+1
    ldy #0
draw_center_loop
    lda (arr),y
	and player_udg,x
	sta player_touch,x
    lda (arr),y
    ora player_udg,x
    sta player_udg,x

    lda (arr2),y
	and player_udg+24,x
	sta player_touch+24,x
    lda (arr2),y
    ora player_udg+24,x
    sta player_udg+24,x
    inx
    iny
    cpy #16
    bne draw_center_loop

    ldx px
    ldy py
    jsr ConvertXYToScreenAddr

	ldx #5
-
	lda draw_player_chrs,x
	ldy draw_player_offsets,x
	sta (scr_ptr),y
	dex
	bpl -

coll_check
	; now check for collisions
	ldy #5
	ldx #(6*8-1)
--
	lda #0
	sta tmp
-
	lda tmp
	ora player_touch-1,x
	sta tmp
	dex
	txa
	and #7
	bne -
	lda tmp
	beq +
	lda player_overlap,y
	jsr try_killed
+
	dey
	bpl --
    rts

try_killed
	cmp #BUSH
	beq kill_player
	cmp #STAL
	beq kill_player
	cmp #PLATFORM2
	beq dont_kill_player
	cmp #SOLID_CHR
	beq dont_kill_player
	cmp #GUARDIAN_CHR
	bcs kill_player
	rts
kill_player
    lda #1
    sta dead
dont_kill_player
    rts

DeathFlash
	lda #8
	sta 36879

	; flash screen attributes blue and white
	ldy #12
-
	lda #BLUE
	jsr ColFlash
	lda #240
	sta $900c
	jsr WaitForRaster
	jsr WaitForRaster
	lda #WHITE
	jsr ColFlash
	lda #0
	sta $900c
	jsr WaitForRaster
	jsr WaitForRaster
	dey
	bne -
	rts

ColFlash
	; clear the top part of the screen
	ldx #0
-	sta color_base,x
	sta color_base+118,x
	inx
	bne -
	rts