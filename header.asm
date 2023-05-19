!if 0 {

; cartridge

screen_base = $1e00
map_base = $9400
color_base = $9600

hguard_bmp = $1000 ; 256 bytes (max)
vguard_bmp = $1100 ; 128 bytes

; cartridge header
*=$a000
!word cold_start, warm_start
!text "A0"
!byte $c3, $c2, $cd ; CBM
}

!if 1 {
; 16k tape

screen_base = $1000
map_base = $5c00
color_base = $9400
basic_start = $1200

vguard_bmp = $5e80 ; 128 bytes... needs to run into hguard_bmp (for skylab)
hguard_bmp = $5f00 ; 256 bytes (max)

; basic header
*=basic_start-1
	!word basic_start+1	; load address
    !word basic_end		; next line pointer
	!word 10			; line number
	!byte $9e			; sys
	!text "4621"		; $1200 + 13
	!byte 0				; eol
basic_end
	!word 0				; next line pointer
}

cold_start
warm_start

    sei

    lda #$7f
    sta $911d
    sta $911e

    cld
    ldx #$ff
    txs

;    jsr $fd8d   ; init memory ; slow and unnecessary, so don't do this!
;    jsr $fd52   ; init KERNAL ; corrupts zero page, so don't do this!
    jsr $fdf9   ; init VIAs
    jsr $e518   ; init VIC

; set char ram to $1800
	lda 36869
	and #$f0
	ora #$0e
    sta 36869
