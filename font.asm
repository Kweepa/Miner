fontchars
		; A-Z
        !byte    0,112,136,136,248,136,136,0
        !byte    0,240,136,240,136,136,240,0
        !byte    0,112,136,128,128,136,112,0
        !byte    0,224,144,136,136,144,224,0
        !byte    0,248,128,240,128,128,248,0
        !byte    0,248,128,240,128,128,128,0
        !byte    0,112,136,128,184,136,120,0
        !byte    0,136,136,248,136,136,136,0
        !byte    0,248,32,32,32,32,248,0
        !byte    0,8,8,8,8,136,112,0
        !byte    0,144,160,192,160,144,136,0
        !byte    0,128,128,128,128,128,248,0
        !byte    0,136,216,168,136,136,136,0
        !byte    0,136,200,168,152,136,136,0
        !byte    0,112,136,136,136,136,112,0
        !byte    0,240,136,136,240,128,128,0
        !byte    0,112,136,136,168,152,112,0
        !byte    0,240,136,136,240,144,136,0
        !byte    0,112,128,112,8,136,112,0
        !byte    0,248,32,32,32,32,32,0
        !byte    0,136,136,136,136,136,112,0
        !byte    0,136,136,136,136,80,32,0
        !byte    0,136,136,136,136,168,80,0
        !byte    0,136,80,32,32,80,136,0
        !byte    0,136,136,80,32,32,32,0
        !byte    0,248,16,32,64,128,248,0

		; a-z
        !byte    0,0,96,16,112,144,112,0
        !byte    0,128,128,224,144,144,224,0
        !byte    0,0,96,128,128,128,96,0
        !byte    0,16,16,112,144,144,112,0
        !byte    0,0,96,144,224,128,112,0
        !byte    0,96,128,192,128,128,128,0
        !byte    0,0,112,144,144,112,16,96
        !byte    0,128,128,224,144,144,144,0
        !byte    0,64,0,192,64,64,224,0
        !byte    0,16,0,16,16,16,144,96
        !byte    0,128,160,192,192,160,144,0
        !byte    0,128,128,128,128,128,96,0
        !byte    0,0,208,168,168,168,168,0
        !byte    0,0,224,144,144,144,144,0
        !byte    0,0,96,144,144,144,96,0
        !byte    0,0,224,144,144,224,128,128
        !byte    0,0,112,144,144,112,16,24
        !byte    0,0,96,128,128,128,128,0
        !byte    0,0,96,128,96,16,224,0
        !byte    0,64,224,64,64,64,48,0
        !byte    0,0,144,144,144,144,96,0
        !byte    0,0,136,136,80,80,32,0
        !byte    0,0,136,168,168,168,80,0
        !byte    0,0,136,80,32,80,136,0
        !byte    0,0,144,144,144,112,16,96
        !byte    0,0,240,32,64,128,240,0

		; 0-9
		!byte	0,56,68,76,84,100,56,0
		!byte	0,48,80,16,16,16,124,0
		!byte	0,56,68,4,56,64,124,0
		!byte	0,56,68,24,4,68,56,0
		!byte	0,8,24,40,72,124,8,0
		!byte	0,124,64,120,4,68,56,0
		!byte	0,56,64,120,68,68,56,0
		!byte	0,124,4,8,16,32,32,0
		!byte	0,56,68,56,68,68,56,0
		!byte	0,56,68,68,60,4,56,0

		; ' ' (32), '#' (35),' (39), '-' (45), '.' (46), 
        !byte    0,0,0,0,0,0,0,0
		!byte	 56,68,154,162,162,154,68,56
        !byte    0,64,128,0,0,0,0,0
		!byte    0,0,0,0,120,0,0,0
		!byte    0,0,0,0,0,96,96,0

GetCharDefAddr
	ldx #0
	stx arr2+1
	asl
	asl
	rol arr2+1
	asl
	rol arr2+1
	adc #<fontchars
	sta arr2
	lda arr2+1
	adc #>fontchars
	sta arr2+1
	rts

GetCharWidth
	jsr GetCharDefAddr
	ldy #7
	lda #0
-
	ora (arr2),y
	dey
	bpl -
	cmp #0
	beq +
	ldx #10 ; include a blank pixel line
-
	dex
	lsr
	bcc -
	txa
	rts
+
	lda #4
	rts

ConvertCharToFontChar
	sec
	sbc #32
	tax
	lda chartofontchar,x
	rts

chartofontchar
	!byte 62, 0, 0, 0, 0, 0, 0, 64, 0, 0, 0, 0, 0, 65, 66, 0
	!byte 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0
	!byte 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 0, 0, 0, 0, 0
	!byte 0, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 0, 0, 0, 0, 63

GetStringWidth

	sty stringindex
	
	lda #0
	sta stringwidth
-
	ldy stringindex
	lda (arr),y
	beq +
	iny
	sty stringindex
	jsr ConvertCharToFontChar

	jsr GetCharWidth
	clc
	adc stringwidth
	sta stringwidth
	bcc -
+
	lda stringwidth
	rts

PutFontUDGsOnScreen
	; fill the characters with 255
	ldx #(23*8)
	lda #255
-
	sta propfont_udg-1,x
	dex
	bne -

	; write em to the screen
	ldx #66
-
	txa
	sta screen_base+22*17-66,x
	lda #YELLOW
	sta color_base+22*17-66,x
	inx
	cpx #(66+22)
	bne -
	rts

PrintSpecFontString

	sty stringstart

	jsr PutFontUDGsOnScreen

	jsr GetStringWidth
	lsr stringwidth
	lda #88
	sec
	sbc stringwidth
	sta stringxdiv
	and #7
	sta stringxmod
	lda stringxdiv
	and #$f8
	sta stringxdiv

	ldy stringstart
	sty stringindex
---
	; read a char
	ldy stringindex
	lda (arr),y
	beq ++
	iny
	sty stringindex
	jsr ConvertCharToFontChar
	sta stringcur

	jsr GetCharDefAddr

	ldy #0
	sty stringrow
--
	lda (arr2),y

	sta stringleft
	lda #0
	ldx stringxmod
	beq +
-
	lsr stringleft
	ror
	dex
	bne -
+
	sta stringright

	lda stringxdiv
	clc
	adc stringrow
	tax
	lda propfont_udg,x
	eor stringleft
	sta propfont_udg,x
	lda propfont_udg+8,x
	eor stringright
	sta propfont_udg+8,x

	inc stringrow
	ldy stringrow
	cpy #8
	bne --

	lda stringcur
	jsr GetCharWidth
	clc
	adc stringxmod
	sta stringxmod
	lda stringxmod
	and #8
	clc
	adc stringxdiv
	sta stringxdiv
	lda stringxmod
	and #7
	sta stringxmod

	jmp ---
++	
	rts