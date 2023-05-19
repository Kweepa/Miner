ResetLightBeam
	lda #-1
	sta old_path
	rts

DrawLightBeam
	lda map
	cmp #18
	beq +
	rts
+

	; draw the unchanging top of the beam
	lda #SOLID_CHR
	sta screen_base+22*1+16
	sta screen_base+22*2+16
	sta screen_base+22*3+16
	sta screen_base+22*4+16
	lda #YELLOW
	sta color_base+22*1+16
	sta color_base+22*2+16
	sta color_base+22*3+16
	; don't recolor the last block until we've used the current value

	lda old_path
	bmi ++++

	asl
	tay
	lda beam_paths,y
	sta arr
	lda beam_paths+1,y
	sta arr+1

	ldy #-1
-
	iny
	lda (arr),y
	beq ++
	tax
	lda screen_base,x
	cmp #SOLID_CHR
	bne +
	lda #0
	sta screen_base,x
+
	lda color_base,x
	and #$0f
	cmp #YELLOW
	bne -
	lda #WHITE
	sta color_base,x
	bne -
++
-
	iny
	lda (arr),y
	beq ++
	tax
	lda screen_base+$100,x
	cmp #SOLID_CHR
	bne +
	lda #0
	sta screen_base+$100,x
+
	lda color_base+$100,x
	and #$0f
	cmp #YELLOW
	bne -
	lda #WHITE
	sta color_base+$100,x
	bne -
++
++++

	lda color_base+22*4+16
	and #$0f
	cmp #PURPLE
	beq reflected_off_h1
	lda color_base+22*7+16
	and #$0f
	cmp #BLUE
	beq reflected_off_h2
	lda color_base+22*14+16
	and #$0f
	cmp #RED
	beq reflected_off_h3
	lda #PATH_CLEAR
	beq draw_new_path
reflected_off_h1
	lda color_base+22*4+11
	and #$0f
	cmp #BLUE
	beq reflected_off_h1_v3
	lda color_base+22*4+3
	and #$0f
	cmp #PURPLE
	beq reflected_off_h1_v1
	lda #PATH_H1
	bne draw_new_path
reflected_off_h2
	lda color_base+22*7+11
	and #$0f
	cmp #BLUE
	beq reflected_off_h2_v3
	lda color_base+22*7+7
	and #$0f
	cmp #RED
	beq reflected_off_h2_v2
	lda color_base+22*7+3
	and #$0f
	cmp #PURPLE
	beq reflected_off_h2_v1
	lda #PATH_H2
	bne draw_new_path
reflected_off_h3
	lda color_base+22*14+7
	and #$0f
	cmp #RED
	beq reflected_off_h3_v2
	lda color_base+22*14+3
	and #$0f
	cmp #PURPLE
	beq reflected_off_h3_v1
	lda #PATH_H3
	bne draw_new_path
reflected_off_h1_v3	
	lda #PATH_H1V3
	bne draw_new_path
reflected_off_h1_v1
	lda #PATH_H1V1
	bne draw_new_path
reflected_off_h2_v3
	lda #PATH_H2V3
	bne draw_new_path
reflected_off_h2_v2
	lda #PATH_H2V2
	bne draw_new_path
reflected_off_h2_v1
	lda #PATH_H2V1
	bne draw_new_path
reflected_off_h3_v2
	lda #PATH_H3V2
	bne draw_new_path
reflected_off_h3_v1
	lda #PATH_H3V1

draw_new_path

	sta old_path
	
	asl
	tay
	lda beam_paths,y
	sta arr
	lda beam_paths+1,y
	sta arr+1

	ldy #-1
-
	iny
	lda (arr),y
	beq +
	tax
	lda #SOLID_CHR
	sta screen_base,x
	lda #YELLOW
	sta color_base,x
	bne -
+
-
	iny
	lda (arr),y
	beq +
	tax
	lda #SOLID_CHR
	sta screen_base+$100,x
	lda #YELLOW
	sta color_base+$100,x
	bne -
+

	; finish drawing the unchanging top of the beam (see above)
 	lda #YELLOW
	sta color_base+22*4+16

	rts

PATH_CLEAR = 0
PATH_H1 = 1
PATH_H1V3 = 2
PATH_H1V1 = 3
PATH_H2 = 4
PATH_H2V3 = 5
PATH_H2V2 = 6
PATH_H2V2H1 = 7
PATH_H2V1 = 8
PATH_H3 = 9
PATH_H3V2 = 10
PATH_H3V1 = 11

old_path
	!byte 0

beam_paths
	!word path_clear
	!word path_reflected_off_h1
	!word path_reflected_off_h1_v3
	!word path_reflected_off_h1_v1
	!word path_reflected_off_h2
	!word path_reflected_off_h2_v3
	!word path_reflected_off_h2_v2
	!word path_reflected_off_h2_v2_h3
	!word path_reflected_off_h2_v1
	!word path_reflected_off_h3
	!word path_reflected_off_h3_v2
	!word path_reflected_off_h3_v1

path_clear
	!byte 22*5+16,22*6+16,22*7+16,22*8+16,22*9+16,22*10+16,0
	!byte 22*11+16-256,22*12+16-256,22*13+16-256,22*14+16-256,22*15+16-256,0
path_reflected_off_h1
	!byte 22*4+15,22*4+14,22*4+13,22*4+12,22*4+11,22*4+10,22*4+9,22*4+8,22*4+7,22*4+6,22*4+5,22*4+4,22*4+3,22*4+2,22*4+1,22*4,0
	!byte 0
path_reflected_off_h1_v3
	!byte 22*4+15,22*4+14,22*4+13,22*4+12,22*4+11,22*5+11,22*6+11,22*7+11,22*8+11,22*9+11,22*10+11,22*11+11,0
	!byte 22*12+11-256,0
path_reflected_off_h1_v1
	!byte 22*4+15,22*4+14,22*4+13,22*4+12,22*4+11,22*4+10,22*4+9,22*4+8,22*4+7,22*4+6,22*4+5,22*4+4,22*4+3,22*5+3,22*6+3,22*7+3,22*8+3,22*9+3,22*10+3,22*11+3,0
	!byte 22*12+3-256,22*13+3-256,22*14+3-256,22*15+3-256,0
path_reflected_off_h2
	!byte 22*5+16,22*6+16,22*7+16,22*7+15,22*7+14,22*7+13,22*7+12,22*7+11,22*7+10,22*7+9,22*7+8,22*7+7,22*7+6,22*7+5,22*7+4,22*7+3,22*7+2,22*7+1,22*7,0
	!byte 0
path_reflected_off_h2_v3
	!byte 22*5+16,22*6+16,22*7+16,22*7+15,22*7+14,22*7+13,22*7+12,22*7+11,22*8+11,22*9+11,22*10+11,22*11+11,0
	!byte 22*12+11-256,0
path_reflected_off_h2_v2
	!byte 22*5+16,22*6+16,22*7+16,22*7+15,22*7+14,22*7+13,22*7+12,22*7+11,22*7+10,22*7+9,22*7+8,22*7+7,22*8+7,22*9+7,22*10+7,22*11+7,0
	!byte 22*12+7-256,22*13+7-256,22*14+7-256,22*15+7-256, 0
path_reflected_off_h2_v2_h3
	!byte 22*5+16,22*6+16,22*7+16,22*7+15,22*7+14,22*7+13,22*7+12,22*7+11,22*7+10,22*7+9,22*7+8,22*7+7,22*8+7,22*9+7,22*10+7,22*11+7,0
	!byte 22*12+7-256,22*13+7-256,22*14+7-256,22*14+6-256,22*14+5-256,22*14+4-256,22*14+3-256,22*14+2-256,22*14+1-256,22*14-256, 0
	!byte 0
path_reflected_off_h2_v1
	!byte 22*5+16,22*6+16,22*7+16,22*7+15,22*7+14,22*7+13,22*7+12,22*7+11,22*7+10,22*7+9,22*7+8,22*7+7,22*7+6,22*7+5,22*7+4,22*7+3,22*8+3,22*9+3,22*10+3,22*11+3,0
	!byte 22*12+3-256,22*13+3-256,22*14+3-256,22*15+3-256,0
path_reflected_off_h3
	!byte 22*5+16,22*6+16,22*7+16,22*8+16,22*9+16,22*10+16,0
	!byte 22*11+16-256,22*12+16-256,22*13+16-256,22*14+16-256,22*14+15-256,22*14+14-256,22*14+13-256,22*14+12-256,22*14+11-256,22*14+10-256,22*14+9-256
	!byte 22*14+8-256,22*14+7-256,22*14+6-256,22*14+5-256,22*14+4-256,22*14+3-256,22*14+2-256,22*14+1-256,22*14-256,0
path_reflected_off_h3_v2
	!byte 22*5+16,22*6+16,22*7+16,22*8+16,22*9+16,22*10+16,0
	!byte 22*11+16-256,22*12+16-256,22*13+16-256,22*14+16-256,22*14+15-256,22*14+14-256,22*14+13-256,22*14+12-256,22*14+11-256,22*14+10-256,22*14+9-256
	!byte 22*14+8-256,22*14+7-256,22*15+7-256,0
path_reflected_off_h3_v1
	!byte 22*5+16,22*6+16,22*7+16,22*8+16,22*9+16,22*10+16,0
	!byte 22*11+16-256,22*12+16-256,22*13+16-256,22*14+16-256,22*14+15-256,22*14+14-256,22*14+13-256,22*14+12-256,22*14+11-256,22*14+10-256,22*14+9-256
	!byte 22*14+8-256,22*14+7-256,22*14+6-256,22*14+5-256,22*14+4-256,22*14+3-256,22*15+3-256,0
