; TODO
; sound
; title page
; specific guardians

!source "zp.asm"
!source "defines.asm"

!source "header.asm"
!source "gameloop.asm"

!source "map.asm"

*=$1800 + 96*8
!source "happybackground.asm"
!source "font.asm"

!source "guardians.asm"
!source "willy.asm"

!source "music.asm"
!source "util.asm"
!source "input.asm"
!source "mapdata.asm"
!source "strings.asm"
!source "title.asm"
!source "spritedata.asm"
!source "graphicdata.asm"
!source "boot.asm"
!source "lightbeam.asm"

!if 0 {

; cartridge end

eof
*=$bfff
    !byte 0
}