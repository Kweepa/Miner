	lda #0
	sta hi
	sta hi+1
	sta hi+2

start_game

	jsr InitMusic
    jsr TitleScreen
	jsr ResetGame

start_map

	jsr ResetMap

continue_map

    jsr DrawMap
main_loop
    jsr ErasePlayer
    jsr EraseGuardians
    jsr UpdateMoveCounters
    jsr MoveGuardians
    jsr Collide
    jsr DrawExit
	lda #11
	;sta 36879

	; things that don't need to be done in the border
    jsr AnimateBelts
    jsr FlickerKeys
	jsr PlayInGameMusic
    jsr GetPlayerInput
	jsr UpdateAir

    jsr WaitForRasterLineLessThan
    jsr WaitForRasterLine     ; bottom of graphics part of screen
	lda #10
	;sta 36879
    lda dead
    beq +
	jsr InitMusic
	jsr DeathFlash
    dec men
    beq ++
    bne continue_map
+
    lda hit_exit
    beq main_loop
	jsr RunOutAir
    inc map
    bne start_map

++
	jsr BootSquash
	jmp start_game