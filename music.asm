InitMusic
	lda #1
	sta music_bit
	sta music_delay
	lda #255
	sta music_index
	; turn music off
	ldx #4
	lda #0
-	sta $900a-1,x
	dex
	bne -
	; turn volume up
	lda #10
	sta $900e
	rts

PlayInGameMusic

	ldx #1
	dec music_delay
	lda music_delay
	bne ToggleNotes

	; load the next note
	inc music_index
	lda music_index
	cmp #(music_notes_b_1 - music_notes_a_1)
	bne +
	lda #0
	sta music_index
+
	tax
	lda #13
	sta music_delay

	ldy music_notes_a_1,x
	lda music_notes_1,y
	sta music_note
	lda music_mods_1,y
	sta music_mod

	ldy music_notes_b_1,x
	lda music_notes_1,y
	sta music_note+1
	lda music_mods_1,y
	sta music_mod+1

	ldx #1 ; num channels-1


ToggleNotes
	; now toggle the notes to tune them

    asl music_bit ; roll a bit around a byte
    bcc +
    inc music_bit
+

-   ldy music_mod,x
    lda music_datatable,y
    ldy music_note,x
    and music_bit ; check if rolled bit is set
    beq +
    iny
+   tya
    sta $900a,x ; set channel freq
    dex
    bpl -
    rts

PlayTitleMusic

	ldx #2
	dec music_delay
	lda music_delay
	bne ToggleNotes

	; load the next note
	inc music_index
	lda music_index
	cmp #(music_notes_b_2 - music_notes_a_2)
	bne +
	lda #0
	sta music_index
+
	tax
	lda #13
	sta music_delay

	ldy music_notes_a_2,x
	lda music_notes_2,y
	sta music_note
	lda music_mods_2,y
	sta music_mod

	ldy music_notes_b_2,x
	lda music_notes_2,y
	sta music_note+1
	lda music_mods_2,y
	sta music_mod+1

	ldy music_notes_c_2,x
	lda music_notes_2,y
	sta music_note+2
	lda music_mods_2,y
	sta music_mod+2

	ldx #2
	jmp ToggleNotes

music_datatable
!byte %00000000, %10000000, %10001000, %10010010, %10101010, %11011010, %11101110, %11111110

music_notes_a_1
	!byte 0,0,7,7,0,0,7,7, 0,0,7,7, 0,0,7,7, 0,0,7,7,0,0,7,7, 3,3,10,10,3,3,10,10
	!byte 7,7,14,14,7,7,14,14, 3,3,11,11, 7,7,11,11, 7,7,14,14,7,7,14,14, 3,3,10,10, 7,7,10,10
	; b-c#d-e-f#d-f#  f-c#f e-c-e-
	; b-c#d-e-f#d-f#b-1 a-f#d-f#a-
	; f#g#a#b-c#a#c#x2 d-a#d-x2 c#a#c#x2
	; f#g#a#b-c#a#c#x2 d-a#d-x2 c#x4
music_notes_b_1
	!byte 0,2,3,5,7,3,7,7, 6,2,6,6, 5,1,5,5, 0,2,3,5,7,3,7,12, 10,7,3,7,10,10,10,10
	!byte 7,9,11,12,14,11,14,14, 15,11,15,15, 14,11,14,14, 7,9,11,12,14,11,14,14, 15,11,15,15, 14,14,14,14

; PAL!
music_notes_1
	;      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15
	;     b-0 c-1 c#1 d-1 d#1 e-1 f-1 f#1 g-1 g#1 a-1 a#1 b-2 c-2 c#2 d-2
	!byte 184,188,192,196,199,202,205,208,210,213,215,217,220,221,223,225
music_mods_1
	!byte 7,  7,  4,  0,  3,  4,  3,  2,  7,  2,  5,  7,  0,  7,  6,  4


; blue danube

; note P=D2, Q=F2
;       d-g#g#d-g#g#d-g#g#d-g#g#e-g-g-e-g-g-e-g-g-e-g-g-c#g-g-c#g-g-c#g-g-c#g-g-d-f#f#d-f#f#d-f#f#d-f#f#f#a-a-f#a-a-f#a-a-f#a-a-g-b-b-g-b-b-g-          f#g-g-f#g-g-d-f#f#d-f#f#g-----e-----d-  d-d-
;         a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  a-a-  D-D-  D-D-  D-    D-D-  E-E-  E-E-              a-a-f#a-a-  a-a-  a-a-b-----g-----f#  f#f#
; d-f#a-a---A-A-  F#F#  d-d-f#a-a---A-A-  G-G-  c#c#e-b-b---B-B-  G-G-  c#c#e-b-b---B-B-  F#F#  g-g-f#a-D---P-P-  A-A-  d-d-f#a-D---P-P-  B-B-  E-E-G-B-B-------G#A-Q#------A-F#F#--E-B---A-D-  D-D-

; note: 22 is silence
music_notes_a_2
	!byte 22, 22, 22, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 2, 3, 3, 2, 3, 3, 2, 3, 3, 2, 3, 3, 4, 3, 3, 4, 3, 3, 4, 3, 3, 4, 3, 3, 0, 5, 5, 0, 5, 5, 0, 5, 5, 0, 5, 5, 5, 6, 6, 5, 6, 6, 5, 6, 6, 5, 6, 6, 3, 7, 7, 3, 7, 7, 3, 22, 22, 22, 22, 22, 5, 3, 3, 5, 3, 3, 0, 5, 5, 0, 5, 5, 3, 3, 3, 2, 2, 2, 0, 22, 0, 0, 22, 22, 22, 22
music_notes_b_2
	!byte 22, 22, 22, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 8, 8, 22, 0, 0, 22, 0, 0, 22, 0, 22, 22, 0, 0, 22, 2, 2, 22, 2, 2, 22, 22, 22, 22, 22, 22, 22, 8, 8, 9, 8, 8, 22, 8, 8, 22, 8, 8, 10, 10, 10, 11, 11, 11, 9, 22, 9, 9, 22, 22, 22, 22
music_notes_c_2
	!byte 12, 13, 14, 14, 14, 8, 8, 22, 9, 9, 22, 12, 12, 13, 14, 14, 14, 8, 8, 22, 11, 11, 22, 15, 15, 16, 17, 17, 17, 10, 10, 22, 11, 11, 22, 15, 15, 16, 17, 17, 17, 10, 10, 22, 9, 9, 22, 18, 18, 13, 14, 19, 12, 0, 0, 22, 8, 8, 22, 12, 12, 13, 14, 19, 12, 0, 0, 22, 10, 10, 22, 20, 20, 11, 10, 10, 17, 17, 17, 21, 8, 5, 13, 13, 13, 8, 9, 9, 13, 20, 10, 17, 8, 19, 22, 19, 19, 22, 22, 22, 22
music_notes_2
	;     d-2 g#2 e-2 g-2 c#2 f#2 a-2 b-2 a-1 f#1 b-1 g-1 d-0 f#0 a-0 c#0 e-0 b-0 g-0 d-1 e-1 g#1, 
	!byte 225,234,228,232,223,231,235,237,215,208,220,210,137,161,176,130,149,184,166,196,202,213, 0
music_mods_2
	!byte 4,  1,  6,  7,  6,  5,  3,  4,  5,  2,  0,  7,  1,  3,  2,  0,  7,  7,  5,  0,  4,  2,   0