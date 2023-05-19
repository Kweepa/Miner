TitleScreen

    lda #14 ; blue border, black bg
    sta 36879

	ldx #0
	lda #0
-	sta color_base,x
	sta color_base+256,x
	inx
	bne -

	lda #0
	sta title_jump_progress
	lda #-1
	sta message_index
	lda #1
	sta message_char_countdown

	; fill the characters with 0
	ldx #(22*8)
	lda #0
-
	sta propfont_udg-1,x
	dex
	bne -

	; write em to the screen
	ldx #66
-
	txa
	sta screen_base+22*17-66,x
	lda #WHITE
	sta color_base+22*17-66,x
	inx
	cpx #(66+22)
	bne -

!if 0 {

; draw the block udgs to the screen for reference

	lda $9002
	and #$80
	ora #16
	sta $9002

	ldx #0
-
	lda block_bmps,x
	sta udg_base,x
	lda block_bmps+256,x
	sta udg_base + $100,x
	inx
	bne -

	ldx #0
	ldy #0
-
	txa
	sta screen_base,y
	iny
	iny
	tya
	and #15
	cmp #0
	bne +
	tya
	clc
	adc #16
	tay
+
	inx
	cpx #64
	bne -

}

!if 1 {

	; output the logo

	ldx #(22*6)
-	lda logo-1,x
	sta screen_base + 22*6-1,x
	dex
	bne -

	lda #5
	sta tmp
-
	ldy tmp
	lda logocols,y
	tax
	lda logooffs,y
	jsr ColorALine
	dec tmp
	bpl -

    ldx #6
    ldy #20
    lda #STRINGPRESSJUMP
    jsr PrintString
}

	jsr InitMusic

-
	jsr PlayTitleMusic
	jsr WaitForRasterLineLessThan

	lda 36869
	and #$f0
    sta 36869

	jsr ScrollMessage
	jsr WaitForRasterLine

	lda 36869
	and #$f0
	ora #$0e
    sta 36869

    jsr GetJumpIsPressed
	beq +
	lda #1
+
	; should be 0, 1, 0
	ldx title_jump_progress
	cmp title_jump_sequence,x
	bne -
	inc title_jump_progress
	lda title_jump_progress
	cmp #3
	bne -

	jsr InitMusic

	rts

title_jump_sequence
	!byte 0, 1, 0

title_jump_progress
	!byte 0

ColorALine
	; A = screen offset
	; X = color
	; Y erased

	sta arr
	lda #>color_base
	sta arr+1
	txa	
	ldy #21
-	sta (arr),y
	dey
	bpl -
	rts

ScrollMessage
	dec message_char_countdown
	lda message_char_countdown
	bne ++

	; write the next character to UDG 23
	; note: the message is 256 chars long, so it doesn't need wrapped
	inc message_index
	ldx message_index
	lda message,x

	jsr ConvertCharToFontChar
+
	jsr GetCharWidth ; also puts char def in (arr2)
	sta message_char_countdown

	ldy #7
-
	lda (arr2),y
	sta propfont_udg + 22*8,y
	dey
	bpl -


++
	; perform the pixel scroll
	lda #7
	sta tmp
--
	lda tmp
	clc
	adc #(22*8)
	tax

	ldy #23
-
	lda propfont_udg,x
	rol
	sta propfont_udg,x
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	dex
	dey
	bne -

	dec tmp
	bpl --

	rts

message_index
	!byte 0
message_char_countdown
	!byte 0

message
	!text ".  .  .  .  .  .  .  .  .  .  . MANIC MINER . . "
	!text 127, " BUG-BYTE ltd. 1983 . . By Matthew Smith . . . "
	!text "VIC-20 version by Steve McCrea 2018 . . . "
	!text "Q to P - Left and Right . . Bottom row - Jump . . "
	!text "Guide Miner Willy through 20 lethal caverns"
	!text " .  .  .  .  .  .  .  .  "

logo
	!byte	$20, $20, $e9, $df, $e9, $df, $20, $20, $e9, $df, $20, $df, $20, $a0, $75, $a0, $75, $e9, $a0, $a0, $df, $20
	!byte	$20, $e9, $a0, $a0, $a0, $a0, $df, $e9, $ec, $a0, $df, $a0, $df, $a0, $75, $a0, $75, $a0, $75, $20, $20, $20
	!byte	$e9, $a0, $69, $5f, $69, $5f, $a0, $a0, $69, $5f, $a0, $a0, $5f, $a0, $75, $a0, $75, $5f, $a0, $a0, $a0, $df
	!byte	$20, $20, $20, $e9, $df, $e9, $df, $20, $a0, $75, $df, $20, $a0, $75, $a0, $e4, $e4, $20, $a0, $a0, $df, $20
	!byte	$20, $20, $e9, $a0, $a0, $a0, $a0, $df, $a0, $75, $a0, $df, $a0, $75, $a0, $e4, $e4, $20, $a0, $fe, $69, $20
	!byte	$20, $e9, $a0, $69, $5f, $69, $5f, $a0, $a0, $75, $a0, $5f, $a0, $75, $a0, $a0, $a0, $75, $a0, $5f, $df, $20
logocols
	!byte RED,PURPLE,RED,GREEN,YELLOW,GREEN
logooffs
	!byte 22*6,22*7,22*8,22*9,22*10,22*11