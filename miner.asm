; TODO
; sound
; music
; sign of conveyor
; vertical guardian
; air
; score
; title page
; end game (foot)
; high score?

; 10 SYS4109

; zero page
tmp             = $02
arr             = $03
scr_add         = $05
col_add         = $07
num             = $09
run             = $0a
typ             = $0b
col             = $0c
mov             = $0d

xadd            = $0e
yadd            = $0f
px              = $10
py              = $11
arr2            = $13
map_add         = $15
dead            = $17
on_ground       = $18
key_count       = $19
udg_add         = $1a
play_udg        = $1c
newy            = $1f

hx              = $20
hy              = $21
hl              = $22
hr              = $23
hd              = $24

exitscr         = $27
lastxmove       = $29
was_on_ground   = $2a
airtime         = $2b
men             = $2c
menx            = $2d
map             = $2e
hit_exit        = $2f
exit_col		= $30

rasterline      = $36
stickleft       = $37
stickright      = $38
stickup         = $39
stickfire       = $3a
stickcontribute = $3b
jumpIsPressed   = $3c

music_index     = $3d
music_delay     = $3e
music_note		= $3f ; (2 bytes)
music_mod       = $41 ; (2 bytes)
music_bit       = $43

ts              = $72 ; start of temporaries

num_guardians   = $80
guardian_index  = $81
guardian_data   = $82 ; 5*4

key_adds        = $96 ; 2*5
belt_spd        = $a0

left_right_ctr  = $a1
crumble_ctr     = $a2

BLACK = 0
WHITE = 1
RED = 2
CYAN = 3
PURPLE = 4
GREEN = 5
BLUE = 6
YELLOW = 7

EXIT = 1
KEY = 2
STAL = 3
BUSH = 4
BELT = 5
PLATFORM = 6
BLOCK = 7
CRUMBLE = 8 ; to 15

RASTERLINE_PAL      = $66
RASTERLINE_NTSC     = $54


udg_addr = $1c00 ; 16 chars
guardian_udgs = udg_addr + 16*8 ; 6 guardians x 6 chars = 36 chars
player_udg = guardian_udgs + 6*6*8 ; 6 chars starting @52

PLAY_CHAR = 52
HEAD_CHR = 62
SOLID_CHR = 63

hguard_bmp = $1000 ; 256 bytes (max)
vguard_bmp = $1100 ; 128 bytes

; cartridge header
*=$a000
!word cold_start, warm_start
!text "A0"
!byte $c3, $c2, $cd ; CBM

; tape header
;*=$1001
;        BYTE    $0B, $10, $0A, $00, $9E, $34, $31, $30, $39, $00, $00, $00

cold_start
warm_start

    sei

    lda #$7f
    sta $911d
    sta $911e

    cld
    ldx #$ff
    txs

    jsr $fd8d   ; init memory
    jsr $fd52   ; init KERNAL
    jsr $fdf9   ; init VIAs
    jsr $e518   ; init VIC

; set char ram to $1c00
    lda #$ff
    sta 36869

	jsr InitMusic

;    lda #RASTERLINE_PAL
;    sta rasterline

start_game

    jsr TitleScreen

; to set screen to $1000, poke 36866,#$16:poke36869,#$cf

    lda #0
    sta map

    lda #3
    sta men

start_map

    lda #1
    ldx #10
key_reset_loop
    sta key_adds-1,x
    dex
    bne key_reset_loop

    ; ldx #0 ; already 0
    stx exitscr+1

    lda #1
    sta hit_exit
    sta left_right_ctr
    sta crumble_ctr

	jsr CopyAndFlipGuardian
	jsr CopyBlockBmps
    
continue_map

    jsr DrawMap
main_loop
    jsr GetPlayerInput
;    lda #11
;    sta 36879
    jsr ErasePlayer
    jsr EraseGuardians
    jsr UpdateMoveCounters
    jsr MoveGuardians
    jsr Collide
;    lda #10
;    sta 36879
    jsr AnimateBelts
    jsr DrawExit
    jsr FlickerKeys

	jsr PlayMusic

    jsr WaitForRasterLineLessThan
    jsr WaitForRasterLine     ; bottom of graphics part of screen
    lda dead
    beq skip_dead
	jsr InitMusic
    dec men
    beq start_game
    bne continue_map
skip_dead
    lda hit_exit
    bne main_loop
    inc map
    bne start_map

UpdateMoveCounters
    dec left_right_ctr
    bpl skip_left_right_cycle
    lda #3
    sta left_right_ctr
skip_left_right_cycle
    dec crumble_ctr
    bpl skip_crumble_cycle
    lda #6
    sta crumble_ctr
skip_crumble_cycle
    rts

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

PlayMusic

	dec music_delay
	ldx music_delay
	bne ++

	; load the next note
	inc music_index
	lda music_index
	and #$3f
	tax
+
	lda #13
	sta music_delay

	ldy music_notes_a,x
	lda music_notes,y
	sta music_note
	lda music_mods,y
	sta music_mod

	ldy music_notes_b,x
	lda music_notes,y
	sta music_note+1
	lda music_mods,y
	sta music_mod+1
	
++
	; now toggle the notes to tune them

    asl music_bit ; roll a bit around a byte
    bcc +
    inc music_bit
+   ldx #$01 ; loop over channels

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

music_datatable
!byte %00000000, %10000000, %10001000, %10010010, %10101010, %11011010, %11101110, %11111110

music_notes_a
	!byte 0,0,7,7,0,0,7,7, 0,0,7,7, 0,0,7,7, 0,0,7,7,0,0,7,7, 3,3,10,10,3,3,10,10
	!byte 7,7,14,14,7,7,14,14, 3,3,11,11, 7,7,11,11, 7,7,14,14,7,7,14,14, 3,3,10,10, 7,7,10,10
	; b-c#d-e-f#d-f#  f-c#f e-c-e-
	; b-c#d-e-f#d-f#b-1 a-f#d-f#a-
	; f#g#a#b-c#a#c#x2 d-a#d-x2 c#a#c#x2
	; f#g#a#b-c#a#c#x2 d-a#d-x2 c#x4
music_notes_b
	!byte 0,2,3,5,7,3,7,7, 6,2,6,6, 5,1,5,5, 0,2,3,5,7,3,7,12, 10,7,3,7,10,10,10,10
	!byte 7,9,11,12,14,11,14,14, 15,11,15,15, 14,11,14,14, 7,9,11,12,14,11,14,14, 15,11,15,15, 14,14,14,14

; PAL!
music_notes
	;      0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15
	;     b-0 c-1 c#1 d-1 d#1 e-1 f-1 f#1 g-1 g#1 a-1 a#1 b-2 c-2 c#2 d-2
	!byte 184,188,192,196,199,202,205,208,210,213,215,217,220,221,223,225
music_mods
	!byte 7,  7,  4,  0,  3,  4,  3,  2,  7,  2,  5,  7,  0,  7,  6,  4

CopyBlockBmps
	ldx #(9*8)
-	lda block_bmps-1,x
	sta udg_addr-1,x
	dex
	bne -

	; shift down the crumbling blocks (9-15 copied from 8)
	ldx #0
-
	lda udg_addr+8*8,x
	sta udg_addr+8*8+9,x
	inx
	cpx #56
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
	sta udg_addr+9*8,x
+	inx
	cpx #56
	bne -

	; and fill 62 & 63 (solid block & head)
	ldx #8
-	lda #255
	sta udg_addr+SOLID_CHR*8-1,x
	lda player_bmp-1,x
	sta udg_addr+HEAD_CHR*8-1,x
	dex
	bne -

	rts

CopyAndFlipGuardian
	; copy down guardian bmp
	ldx #128
-	lda guardian_bmp-1,x
	sta hguard_bmp-1,x
	dex
	bne -

	; flip sprites
	; 8x8 sprite arrangement before -> after
	; ABEFIJMN -> NMJIFEBA
	; CDGHKLOP -> POLKHGDC (with bits reversed)
	; map left to right: keep bits 0-2 the same (within char block)
	; then 0<->13, 1<->12, 4<->9, 5<->10
	; 2<->15, 3,<->14
	; 1<->15, 3<->13
	; i.e. flip bit 3
	; 
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
	eor #$e8 ; set bit 7, flip bits 3,5,6
	tay
	lda flippedbyte
	sta hguard_bmp,y
	dex
	bpl --
	rts

DrawMap
    jsr ClearScreen

    lda #0
    sta dead
    sta key_count

    ldx #12
    ldy #144
    lda map
    jsr PrintString

    lda map
    asl
    tax
    lda maptab,x
    sta arr
    lda maptab+1,x
    sta arr+1

    ldx men
    dex
    dex
draw_men_loop
    lda #HEAD_CHR
    sta $1fce,x
    lda #3
    sta $97ce,x
    dex
    bpl draw_men_loop

    ldx #21
top_loop
    lda #SOLID_CHR
    sta $1e00,x
    lda #2
    sta $9600,x
    dex
    bpl top_loop

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
    sta scr_add
    sta col_add
    sta map_add

; load hi byte of address (+run count)
    lda (arr),y
    iny
    pha
    and #$01
    ora #$1e
    sta scr_add + 1
    clc
    adc #$76
    sta map_add + 1
    adc #$02
    sta col_add + 1

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
    cmp #EXIT
    bne not_exit
	lda col
	sta exit_col
    lda exitscr+1
    bne run_normal_col
    lda scr_add
    sta exitscr
    lda scr_add+1
    sta exitscr+1
    bne run_normal_col
not_exit
    cmp #KEY
    bne run_normal_col
    txa
    pha
    asl
    tax
    lda key_adds-1,x
    beq run_got_key
    inc key_count
    lda col_add
    sta key_adds-2,x
    lda col_add+1
    sta key_adds-1,x
    pla
    tax
    sta (col_add),y
    jmp run_custom_col
run_got_key
    pla
    tax
    jmp run_got_key2
run_normal_col
    lda col
    sta (col_add),y
run_custom_col
    lda typ
    sta (scr_add),y
    sta (map_add),y
run_got_key2

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
    sta num_guardians
    asl
    asl
    clc
    adc num_guardians
    sta tmp
    ldx #0
copy_guardian_data_loop
    lda (arr),y
    iny
    sta guardian_data,x
    inx
    dec tmp
    bne copy_guardian_data_loop

    lda (arr),y
    iny
    sta 36879

    lda (arr),y
    iny
    sta px
	
	lda (arr),y
	iny
	sta py

    lda (arr),y
    iny
    sta belt_spd

    lda #0
    sta xadd
    lda #27
    sta airtime

    jsr DrawPlayer
    rts

FlickerKeys
    ldx #0
flicker_key_loop
    lda key_adds+1,x
    beq dont_flicker_this_key
    lda (key_adds,x)
    clc
    adc #1
    and #7
    sta (key_adds,x)
dont_flicker_this_key
    inx
    inx
    cpx #10
    bne flicker_key_loop
    rts

DrawExit
	lda #EXIT
	ldy #0
	sta (exitscr),y
	iny
	sta (exitscr),y
	ldy #22
	sta (exitscr),y
	iny
	sta (exitscr),y

    lda exitscr
    sta col_add
    lda exitscr+1
    clc
    adc #$78
    sta col_add+1

    lda key_count
    bne +
	lda exit_col
    eor #$07 ; flash exit
	sta exit_col
+
    lda exit_col
    ldy #0
    sta (col_add),y
    iny
    sta (col_add),y
    ldy #22
    sta (col_add),y
    iny
    sta (col_add),y

    rts

ClearScreen
    ldx #0
clear_loop
    lda #0
    sta $1e00,x
    sta $1f00,x
    sta $9400,x
    sta $9500,x
    lda #1
    sta $9600,x
    sta $9700,x
    dex
    bne clear_loop
    rts

CopyDownGuardianData
    lda guardian_index
    asl
    asl
    clc
    adc guardian_index
    adc #4
    tay
    ldx #4
copy_down_guardian_data_loop
    lda guardian_data,y
    sta hx,x
    dey
    dex
    bpl copy_down_guardian_data_loop
    rts

CopyUpGuardianData
    lda guardian_index
    asl
    asl
    clc
    adc guardian_index
    adc #4
    tay
    ldx #4
copy_up_guardian_data_loop
    lda hx,x
    sta guardian_data,y
    dey
    dex
    bpl copy_up_guardian_data_loop
    rts

EraseGuardians
    lda #0
    sta guardian_index
erase_guardian_loop
    jsr CopyDownGuardianData
    ldx hx
    ldy hy
    jsr ConvertXYToScreenAddr
    ldy #22
    lda #0
    sta (scr_add),y
    lda #1
    sta (col_add),y
    iny
    lda #0
    sta (scr_add),y
    lda #1
    sta (col_add),y
    ldy #44
    lda #0
    sta (scr_add),y
    lda #1
    sta (col_add),y
    iny
    lda #0
    sta (scr_add),y
    lda #1
    sta (col_add),y

    inc guardian_index
    lda guardian_index
    cmp num_guardians
    bne erase_guardian_loop
    rts

GetGuardianBmpAdd
    lda hx
    and #$03
    asl
    asl
    asl
    asl
    asl
    clc
    adc #<hguard_bmp
    sta arr
    lda hd
    and #$80
    adc arr
    sta arr
    lda #>hguard_bmp
    adc #0
    sta arr+1
    rts

MoveGuardians
    lda #0
    sta guardian_index
move_guardian_loop
    jsr CopyDownGuardianData
    lda left_right_ctr
    beq do_move_guardians
    bne move_on
do_move_guardians
    ; update x
    lda hx
    clc
    adc hd
    sta hx
    lda hd
    bmi check_left
    lda hx
    cmp hr
    bne move_on
    lda #$ff
    sta hd
    bne move_on
check_left
    lda hx
    cmp hl
    bne move_on
    lda #1
    sta hd

move_on
    jsr GetGuardianBmpAdd
    lda guardian_index
    asl
    clc
    adc guardian_index
    asl
    sta ts              ; x6
    asl
    asl
    asl                 ; x48
    adc #<guardian_udgs
    sta arr2
    lda #>guardian_udgs
    adc #0
    sta arr2+1
    ldy #31
copy_guardian_bmp_loop
    lda (arr),y
    sta (arr2),y
    dey
    bpl copy_guardian_bmp_loop
    
    ; plaster to screen
    ldx hx
    ldy hy
    jsr ConvertXYToScreenAddr

    lda ts
    clc
    adc #16
    sta tmp

    lda #7
    ldy #22
    sta (col_add),y
    lda tmp
    sta (scr_add),y
    iny
    lda #7
    sta (col_add),y
    inc tmp
    lda tmp
    sta (scr_add),y
    ldy #44
    lda #7
    sta (col_add),y
    inc tmp
    lda tmp
    sta (scr_add),y
    iny
    lda #7
    sta (col_add),y
    inc tmp
    lda tmp
    sta (scr_add),y

    ; check for collision with player
    ; if px - hx + 4 <= 0 // left (3=playerwidth)
    ; || px - hx - 5 >= 0 // right (5=guardianwidth)
    ; || py - hy + 15 < 0 // top
    ; || py - hy - 16 >= 0 // bottom
    lda px
    sec
    sbc hx
    clc
    adc #3
    bmi no_guardian_collision
    sec
    sbc #8
    bpl no_guardian_collision
    lda py
    sec
    sbc hy
    clc
    adc #15
    bmi no_guardian_collision
    sec
    sbc #31
    bpl no_guardian_collision
    lda #1
    sta dead
no_guardian_collision

    jsr CopyUpGuardianData

    inc guardian_index
    lda guardian_index
    cmp num_guardians
    beq move_guardians_end
    jmp move_guardian_loop
move_guardians_end
    rts

AnimateBelts
    lda left_right_ctr
    bne no_belt_animate
    lda belt_spd
    bpl belt_animate_right
    lda udg_addr + 40
    asl
    rol udg_addr + 40
    lda udg_addr + 42
    lsr
    ror udg_addr + 42
    rts
belt_animate_right
    lda udg_addr + 40
    lsr
    ror udg_addr + 40
    lda udg_addr + 42
    asl
    rol udg_addr + 42
no_belt_animate
    rts

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
    sta scr_add
    sta map_add
    sta col_add
    lda x22tab + 1,y
    adc #$1e
    sta scr_add + 1
    adc #$76
    sta map_add + 1
    adc #$02
    sta col_add + 1
    rts

try_touch
    lda (map_add),y
    and #$0f
    sta typ
    cmp #EXIT
    beq try_exit
    cmp #KEY
    beq get_key
    cmp #STAL
    beq kill_player
    cmp #BUSH
    beq kill_player
    cmp #BLOCK
    beq do_block
    lda #0
    rts
do_block
    lda #1
    rts

try_exit
    lda key_count
    sta hit_exit
    lda #0 ; return no block
    rts

get_key
    dec key_count
    sty tmp
    lda col_add
    clc
    adc tmp
    sta arr
    lda col_add+1
    adc #0
    sta arr+1
    ldx #0
get_key_loop
    lda key_adds,x
    cmp arr
    bne not_this_key
    lda key_adds+1,x
    cmp arr+1
    bne not_this_key
    lda #1
    sta (col_add),y
    lda #0
    sta (map_add),y
    sta (scr_add),y
    sta key_adds+1,x
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

kill_player
    lda #1
    sta dead
    ; return 1 (block)
    rts

try_touch_below
    lda (map_add),y
    and #$0f
    sta typ
    cmp #KEY
    beq get_key
    cmp #EXIT
    beq try_exit
    cmp #STAL
    beq kill_player
    cmp #BUSH
    beq kill_player
    cmp #BELT
    bcs do_block_below ; if A >= BELT
    lda #0
    rts

do_block_below
    cmp #BELT
    bne try_crumble
    lda belt_spd
    sta xadd
    bne block_below_done
try_crumble
    lda #0
    sta xadd
    lda crumble_ctr
    bne block_below_done
    lda typ
    cmp #CRUMBLE
    bcc block_below_done
    clc
    adc #1
    and #$0f
    sta (map_add),y
    sta (scr_add),y
    bne block_below_done
    lda #1
    sta (col_add),y
block_below_done
    lda #1
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
    lda on_ground
    sta was_on_ground
    lda airtime
    cmp #51
    beq stop_airtime
    inc airtime
    bne air_time_skip
stop_airtime
    lda #0
    sta xadd
    beq air_time_skip
air_time_skip
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
    ldx airtime
    lda jumptab,x
    clc
    adc py
    sta newy
    lda airtime
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
    bne +
	dey
	dey
+   iny
    jsr try_touch_below
    beq move_up_down
    bne hit_below
look_below_2
    lda was_on_ground
    beq not_falling_off_ledge
    lda #0
    sta xadd
not_falling_off_ledge
    ldy #66
    jsr try_touch_below
    sta tmp
    lda px
    and #$03
    bne +
	dey
	dey
+   iny
    jsr try_touch_below
    ora tmp
    sta tmp
    beq move_up_down
check_jump
    ldx #1
    stx on_ground
    lda #27
    sta airtime
    lda jumpIsPressed
    beq collide_end
    lda #0
    sta airtime
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
    sta airtime
    lda py
    and #$f8
    sta newy
    jmp move_up_down
hit_below
    lda #27
    sta airtime
    lda newy
    and #$f8
    sta newy
    jmp move_up_down

x22tab
!word 0,22,44,66,88,110,132,154,176,198,220,242,264,286,308,330,352,374,396
jumptab ; 54 bytes
!byte -2, -1, -2, -1, -2, -1, -1, -1, -2, -1, -1, 0, -1, -1, -1, 0, -1, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0
!byte 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 2, 1, 1, 1, 2, 1, 2, 1, 2

ErasePlayerBlock
    lda (map_add),y
    and #$0f
    sta (scr_add),y
    rts

ErasePlayer
    ldx px
    ldy py
    jsr ConvertXYToScreenAddr
    ldy #22
    jsr ErasePlayerBlock
    ldy #44
    jsr ErasePlayerBlock
    lda py
    and #$07
    beq scrub_col1
    lda #0
    ldy #66
    jsr ErasePlayerBlock
scrub_col1
    lda px
    and #$03
    beq scrub_col2
    ldy #23
    jsr ErasePlayerBlock
    ldy #45
    jsr ErasePlayerBlock
    lda py
    and #$07
    beq scrub_col2
    ldy #67
    jsr ErasePlayerBlock
scrub_col2
    rts

setudgadd
    lda (scr_add),y
    asl
    asl
    asl
    sta udg_add
    lda #$1c
    sta udg_add+1
    rts

copy_udg
    ldy #7
copy_udg_loop
    lda (udg_add),y
    sta (play_udg),y
    dey
    bpl copy_udg_loop
    rts

DrawPlayer
    ; first read screen bitmaps to player bitmaps
    ldx px
    ldy py
    jsr ConvertXYToScreenAddr
    lda #<player_udg
    sta play_udg
    lda #>player_udg
    sta play_udg+1

    ldy #22
    jsr setudgadd
    jsr copy_udg
    lda play_udg
    clc
    adc #8
    sta play_udg
    ldy #44
    jsr setudgadd
    jsr copy_udg
    lda play_udg
    clc
    adc #8
    sta play_udg
    ldy #66
    jsr setudgadd
    jsr copy_udg

    lda play_udg
    clc
    adc #8
    sta play_udg
    
    ldy #23
    jsr setudgadd
    jsr copy_udg
    lda play_udg
    clc
    adc #8
    sta play_udg
    ldy #45
    jsr setudgadd
    jsr copy_udg
    lda play_udg
    clc
    adc #8
    sta play_udg
    ldy #67
    jsr setudgadd
    jsr copy_udg
    
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
    lda lastxmove
    and #$80
    adc arr
    sta arr
    lda #>player_bmp
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
    ora player_udg,x
    sta player_udg,x
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
    tax
    lda #PLAY_CHAR
    ldy #22
    sta (scr_add),y
    ldy #44
    lda #(PLAY_CHAR + 1)
    sta (scr_add),y
    lda py
    and #$07
    beq draw_col_1_skip
    ldy #66
    lda #(PLAY_CHAR + 2)
    sta (scr_add),y
draw_col_1_skip
    lda px
    and #$03
    beq draw_col_2_skip
    ldy #23
    lda #(PLAY_CHAR + 3)
    sta (scr_add),y
    ldy #45
    lda #(PLAY_CHAR + 4)
    sta (scr_add),y
    lda py
    and #$07
    beq draw_col_2_skip
    ldy #67
    lda #(PLAY_CHAR + 5)
    sta (scr_add),y
draw_col_2_skip
    rts

;
; ScanKeyRow
;
; call with the row in .X
; and the column mask in .Y
; the row is 1,2,4,8... ^ FF
; returns whether pressed in .A
; returns keys pressed in .X
;
; left to right is LSB-MSB
; fe -> 1,3,5,7,9,-,DEL,
; fd ->  ,W,R,Y,I,P,],RET
; fb ->  ,A,D,G,J,L,',
; f7 -> LSH,X,V,N,<,/,
; ef ->  ,Z,C,B,M,>,RSH,
; df -> CTL,S,F,H,K,;,
; bf -> Q,E,T,U,O,[,
; 7f -> 2,4,6,8,0,=,
;
; temps - check with ScanEntireKeyRow
columnmask = ts

ScanKeyRow
    lda #$ff    ; restore DDR for VIA2
    sta $9122
    lda #$00
    sta $9123   ; set data direction for $9121
    stx $9120   ; request row
    sty columnmask
    lda $9121   ; read
    eor #$ff    ; $ff is no keys pressed
    and columnmask
    tax
    beq scan_key_row_skip
    lda #$01    ; key pressed
    rts
scan_key_row_skip
    lda #$00    ; no key pressed
    rts

;
; ScanEntireKeyRow
;
; IN:
; .A contains waspressed
; .X contains row byte
; .Y contains other row byte
; stickcontribute contains the joystick contribution for this action
;
; OUT:
; .X contains ispressed
; .Y contains pressedthisframe
;
; temps - check with ScanKeyRow
ispressed = ts+1
waspressed = ts+2
otherrowbyte = ts+3

ScanEntireKeyRow
    sty otherrowbyte
    ldy #$ff
    sta waspressed
    jsr ScanKeyRow
    sta ispressed
    ldx otherrowbyte
    jsr ScanKeyRow
    ora ispressed
    ora stickcontribute
    sta ispressed
    tax             ; is pressed
    lda waspressed
    eor #$ff
    and ispressed
    tay             ; pressed this frame = (!waspressed & ispressed)
    rts

ScanJoystick
    lda #$0
    sta $9113
    sta $9122    ; set data direction to read (input mode)
    lda $9111
    eor #$ff
    lsr
    lsr
    tay
    and #1
    sta stickup
    tya
    lsr
    lsr
    tay
    and #1
    sta stickleft
    tya
    lsr
    and #1
    sta stickfire
    lda $9120
    eor #$ff
    and #$80    ; bit 7 = right
    clc
    rol
    rol
    sta stickright
    rts

GetPlayerInput
    jsr ScanJoystick
    lda #0
    sta jumpIsPressed
    lda on_ground
    beq player_input_done
        ; left
    ldx #$f7        ; XVN
    ldy #$ff
    jsr ScanKeyRow
    ora stickleft
    cmp #0
    beq player_input_skip
    lda #-1
    sta lastxmove
    clc
    adc xadd
    cmp #-2
    bne player_input_skip2
    lda #-1
player_input_skip2
    sta xadd
player_input_skip
        ; right
    ldx #$ef        ; ZCB
    ldy #$fe        ; not space
    jsr ScanKeyRow
    ora stickright
    cmp #0
    beq player_input_try_jump
    sta lastxmove
    clc
    adc xadd
    cmp #2
    bne player_input_skip3
    lda #1
player_input_skip3
    sta xadd
player_input_try_jump
        ; jump
    ldx #$fb        ; ADG
    ldy #$df        ; SFH
    lda stickfire
    sta stickcontribute
    lda jumpIsPressed
    jsr ScanEntireKeyRow
    stx jumpIsPressed
    txa

player_input_done
    rts


strings_lo
    !byte <string_map1
    !byte <string_map2
    !byte <string_map3
    !byte <string_map4
    !byte <string_map5
    !byte <string_map6
    !byte <string_map7
    !byte <string_map8
    !byte <string_map9
    !byte <string_map10
    !byte <string_map11
    !byte <string_map12
    !byte <string_map13
    !byte <string_map14
    !byte <string_map15
    !byte <string_map16
    !byte <string_map17
    !byte <string_map18
    !byte <string_map19
    !byte <string_map20
    !byte <string_manic
    !byte <string_miner 
    !byte <string_press_jump
strings_hi
    !byte >string_map1
    !byte >string_map2
    !byte >string_map3
    !byte >string_map4
    !byte >string_map5
    !byte >string_map6
    !byte >string_map7
    !byte >string_map8
    !byte >string_map9
    !byte >string_map10
    !byte >string_map11
    !byte >string_map12
    !byte >string_map13
    !byte >string_map14
    !byte >string_map15
    !byte >string_map16
    !byte >string_map17
    !byte >string_map18
    !byte >string_map19
    !byte >string_map20
    !byte >string_manic
    !byte >string_miner
    !byte >string_press_jump

STRINGMANIC = 20
STRINGMINER = 21
STRINGPRESSJUMP = 22

string_map1
    !byte YELLOW
    !text "CENTRAL CAVERN"
    !byte 0
string_map2
    !byte YELLOW
    !text "THE COLD ROOM"
    !byte 0
string_map3
    !byte YELLOW
    !text "THE MENAGERIE"
    !byte 0
string_map4
    !byte YELLOW
    !text "URANIUM MINES"
    !byte 0
string_map5
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map6
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map7
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map8
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map9
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map10
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map11
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map12
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map13
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map14
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map15
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map16
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map17
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map18
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map19
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_map20
    !byte YELLOW
    !text "EUGENE'S LAIR"
    !byte 0
string_manic
    !byte CYAN
    !text "MANIC"
    !byte 0
string_miner
    !byte RED
    !text "MINER"
    !byte 0
string_press_jump
    !byte GREEN
    !text "PRESS JUMP"
    !byte 0

TitleScreen

    jsr ClearScreen

    lda #14
    sta 36879

    ldx #28
    ldy #40
    lda #STRINGMANIC
    jsr PrintString
    ldx #32
    ldy #56
    lda #STRINGMINER
    jsr PrintString
    ldx #20
    ldy #104
    lda #STRINGPRESSJUMP
    jsr PrintString

wait_for_jump_press1
    jsr player_input_try_jump
    bne wait_for_jump_press1

wait_for_jump_press
    jsr player_input_try_jump
    beq wait_for_jump_press

wait_for_jump_press2
    jsr player_input_try_jump
    bne wait_for_jump_press2
    rts

PrintString
    pha
    jsr ConvertXYToScreenAddr
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

print_string_loop
    lda (arr),y
    beq print_string_done
    cmp #32
    beq skip_space
    clc
    adc #64
    sta (scr_add),y
skip_space
    lda tmp
    sta (col_add),y
    iny
    bpl print_string_loop

print_string_done
    rts

maptab
    !word map1, map2, map3, map4, map5, map6, map7, map8, map9, map10
	!word map11, map12, map13, map14, map15, map16, map17, map18, map19, map20

map1

; num types
    !byte 8

    !byte EXIT,BLUE,2 ; type, col, num
    !word 840, 862

    !byte KEY,YELLOW,5
    !word 25, 42, 55, 127, 197

    !byte STAL,CYAN,2
    !word 28, 33

    !byte BUSH,GREEN,4
    !word 125, 129, 211, 293

    !byte BELT,GREEN,1
    !word 7392

    !byte PLATFORM,RED,7
    !word 10884, 176, 732, 774, 1329, 4919, 11104

    !byte BLOCK,YELLOW,2
    !word 720, 811

    !byte CRUMBLE,RED,3
    !word 1165, 657, 1837

; num guardians
    !byte 1
    !byte 20,64,16,35,1 ; x,y,min,max,speed

; bg colour, player xy, belt speed
    !byte 10, 4, 112, -1

map2

    !byte 9
    
    !byte EXIT,RED,2
    !word 840, 862

    !byte KEY,YELLOW,5
    !word 49,60,194,222,300

    !byte STAL,CYAN,1
    !word 65

    !byte BELT,YELLOW,1
    !word 1290

    !byte PLATFORM,PURPLE,7
    !word 104,6276,1192,176,1763,1320,11104

    !byte BLOCK,YELLOW,1
    !word 4642

    !byte BLOCK,YELLOW,130
    !word 3736,3243

    !byte CRUMBLE,PURPLE,5
    !word 614,684,1713,1279,1338

    !byte CRUMBLE,PURPLE,130
    !word 2264,2265

; num guardians
    !byte 2
    !byte 20,32,0,47,1
    !byte 56,112,36,83,1

; bg colour, player xy, belt speed
    !byte 106, 4, 112, -1

map3
    !byte 6

    !byte EXIT,BLUE,2
    !word 796, 818

    !byte KEY,YELLOW,5
    !word 25,31,38,168,175

    !byte STAL,RED,3
    !word 41,55,264

    !byte BELT,RED,1
    !word 1760

    !byte PLATFORM,CYAN,8
    !word 1024+132,1536+176,1024+195,260+1536,274+1536,289+1536,324+2560,11104

    !byte CRUMBLE,CYAN,1
    !word 135+9216

; num guardians
    !byte 3
    !byte 36,32,0,35,-1
    !byte 48,32,40,83,1
    !byte 48,112,0,59,-1

; bg colour, player xy, belt speed
    !byte 10, 4, 112, -1

map4
    !byte 7
    
    !byte EXIT,BLUE,2
    !word 64+512,86+512
    
    !byte KEY,YELLOW,5
    !word 22,52,61,164,175

    !byte STAL,CYAN,2
    !word 26,302

    !byte BELT,PURPLE,1
    !word 242+512

    !byte PLATFORM,YELLOW,16
    !word 101+1536,129+1536,136,143,162,168+512,202+512
    !word 216+512,232+512,263,272+512,279+512,289+512
    !word 306+512,320,11104
    
    !byte BLOCK,CYAN,1
    !word 32+5632

    !byte CRUMBLE,YELLOW,1
    !word 176+512

; num guardians
    !byte 2
    !byte 0,112,0,23,1
    !byte 28,112,20,43,1

; bg colour, player xy, belt speed
    !byte 10, 80, 112, 1
	
map5
	!byte 9
	
    !byte EXIT,WHITE,2
    !word 22*14+10+(1<<9), 22*15+10+(1<<9)
    
    !byte KEY,YELLOW,5
    !word 22*2+21, 22*7+6, 22*8+20, 22*13+4, 22*13+6

    !byte STAL,PURPLE,1
    !word 22+14
	
	!byte BUSH,YELLOW,4
	!word 22*5+17, 22*8+15, 22*15+2, 22*15+17+(1<<9)

    !byte BELT,YELLOW,1
    !word 22*9+12+(6<<9)

    !byte PLATFORM,CYAN,9
    !word 22*6+(8<<9), 22*6+16+(2<<9), 22*7+20+(1<<9), 22*10+2+(6<<9), 22*12+1+(7<<9), 22*12+12+(4<<9)
	!word 22*12+21, 22*14, 22*16+(21<<9)
    
    !byte BLOCK,GREEN,1+128
    !word 22*13+5+(2<<9)

    !byte BLOCK,GREEN,3
    !word 22*14+9+(3<<9), 22*15+9+(7<<9), 22*16+4+(12<<9)

    !byte CRUMBLE,GREEN,2
    !word 22*6+12+(3<<9), 22*12

; num guardians
    !byte 2
    !byte 27,32,0,27,0
    !byte 8,64,8,27,1

; bg colour, player xy, belt speed
    !byte 46, 0, 32, -1
	
map6
map7
map8
map9
map10
map11
map12
map13
map14
map15
map16
map17
map18
map19
map20
	
player_bmp
    !byte    $06,$3e,$7c,$34,$3e,$3c,$18,$3c
    !byte    $7e,$7e,$f7,$fb,$3c,$76,$6e,$77
    !byte    $00,$00,$00,$00,$00,$00,$00,$00
    !byte    $00,$00,$00,$00,$00,$00,$00,$00

    !byte    $01,$0f,$1f,$0d,$0f,$0f,$06,$0f
    !byte    $1f,$1b,$1b,$1d,$0f,$06,$06,$07
    !byte    $80,$80,$00,$00,$80,$00,$00,$00
    !byte    $80,$80,$80,$80,$00,$00,$00,$00

    !byte    $00,$03,$07,$03,$03,$03,$01,$03
    !byte    $07,$07,$0f,$0f,$03,$07,$06,$07
    !byte    $60,$e0,$c0,$40,$e0,$c0,$80,$c0
    !byte    $e0,$e0,$70,$b0,$c0,$60,$e0,$70

    !byte    $00,$00,$01,$00,$00,$00,$00,$00
    !byte    $01,$03,$07,$06,$00,$01,$03,$03
    !byte    $18,$f8,$f0,$d0,$f8,$f0,$60,$f0
    !byte    $f8,$fc,$fe,$f6,$f8,$da,$0e,$8c


    !byte    $60,$7c,$3e,$2c,$7c,$3c,$18,$3c
    !byte    $7e,$7e,$ef,$df,$3c,$6e,$76,$ee
    !byte    $00,$00,$00,$00,$00,$00,$00,$00
    !byte    $00,$00,$00,$00,$00,$00,$00,$00

    !byte    $18,$1f,$0f,$0b,$1f,$0f,$06,$0f
    !byte    $1f,$3f,$7f,$6f,$1f,$5b,$70,$21
    !byte    $00,$00,$80,$00,$00,$00,$00,$00
    !byte    $80,$c0,$e0,$60,$00,$80,$c0,$c0

    !byte    $06,$07,$03,$02,$07,$03,$01,$03
    !byte    $07,$07,$0e,$0d,$03,$06,$07,$0e
    !byte    $00,$c0,$e0,$c0,$c0,$c0,$80,$c0
    !byte    $e0,$e0,$f0,$f0,$c0,$e0,$60,$e0

    !byte    $01,$01,$00,$00,$01,$00,$00,$00
    !byte    $01,$01,$01,$01,$00,$00,$00,$00
    !byte    $80,$f0,$f8,$b0,$f0,$f0,$60,$f0
    !byte    $f8,$d8,$d8,$b8,$f0,$60,$60,$e0


guardian_bmp
    !byte    $1f,$39,$19,$0f,$9f,$5f,$ff,$5e
    !byte    $20,$e0,$e0,$20,$00,$80,$c0,$00
    !byte    $9f,$1f,$0e,$1f,$bb,$71,$20,$11
    !byte    $c0,$80,$00,$00,$a0,$c0,$80,$00

    !byte    $07,$0e,$06,$23,$17,$17,$3f,$17
    !byte    $c4,$7c,$7c,$c4,$c0,$e0,$f0,$f0
    !byte    $17,$27,$03,$03,$06,$06,$1c,$06
    !byte    $f0,$e0,$80,$80,$c0,$c0,$70,$c0

    !byte    $01,$03,$01,$00,$09,$05,$0f,$05
    !byte    $f2,$9e,$9e,$f2,$f0,$f8,$fc,$e0
    !byte    $09,$01,$00,$00,$00,$00,$00,$01
    !byte    $fc,$f8,$e0,$e0,$e0,$e0,$e0,$f0

    !byte    $00,$00,$00,$00,$00,$00,$03,$00
    !byte    $7d,$e7,$67,$3d,$7c,$7f,$fc,$78
    !byte    $00,$00,$00,$00,$00,$00,$01,$00
    !byte    $7c,$7f,$38,$38,$6c,$6c,$c7,$6c


block_bmps
    !byte    $00,$00,$00,$00,$00,$00,$00,$00 ; space
    !byte    $ff,$93,$b7,$ff,$93,$b7,$ff,$ff
    !byte    $30,$48,$88,$90,$68,$04,$0a,$04
    !byte    $ff,$fe,$7e,$7c,$4c,$4c,$08,$08
    !byte    $44,$28,$94,$51,$35,$d6,$58,$10
    !byte    $3c,$66,$c3,$66,$00,$99,$ff,$00
    !byte    $ff,$ff,$b7,$dc,$8b,$80,$00,$00
    !byte    $ff,$22,$ff,$88,$ff,$22,$ff,$88
    !byte    $ff,$db,$a5,$24,$52,$20,$08,$00
    !byte    $00,$ff,$db,$a5,$24,$52,$20,$08
    !byte    $00,$00,$ff,$db,$a5,$24,$52,$20
    !byte    $00,$00,$00,$ff,$db,$a5,$24,$52
    !byte    $00,$00,$00,$00,$ff,$db,$a5,$24
    !byte    $00,$00,$00,$00,$00,$ff,$db,$a5
    !byte    $00,$00,$00,$00,$00,$00,$ff,$db
    !byte    $00,$00,$00,$00,$00,$00,$00,$ff

    !byte $ff,$ff,$ff,$ff,$ff,$ff,$ff,$ff ; 46
    !byte $06,$3e,$7c,$34,$3e,$3c,$18,$3c ; 47

eof
*=$bfff
    !byte 0