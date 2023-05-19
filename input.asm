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
	lda xadd
	bne player_input_try_jump
        ; left
    ldx #$bf        ; QET...
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
    ldx #$fd        ; WRY...
    ldy #$ff
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
    ldx #$f7        ; bottom
    ldy #$ef        ; row
    lda stickfire
    sta stickcontribute
    lda jumpIsPressed
    jsr ScanEntireKeyRow
    stx jumpIsPressed
    txa

player_input_done
    rts

GetJumpIsPressed
    jsr ScanJoystick
    lda #0
    sta jumpIsPressed
	jmp player_input_try_jump