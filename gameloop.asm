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
	jsr DrawLightBeam

	jsr FinalBarrierUpperSettings

	; things that don't need to be done in the border
    jsr AnimateBelts
    jsr FlickerKeys
	jsr PlayInGameMusic
    jsr GetPlayerInput
	jsr UpdateAir

	jsr FinalBarrierLowerSettings

    jsr WaitForRasterLineLessThan
    jsr WaitForRasterLine     ; bottom of graphics part of screen
    lda dead
    beq +
	jsr InitMusic
	jsr DeathFlash
	; inc men ; trainer
	nop
	nop
    dec men
    beq ++
    bne continue_map
+
    lda hit_exit
    beq main_loop
    inc map
	jsr AddExtraMan
	jsr RunOutAir
    bne start_map

++
	jsr BootSquash
	jmp start_game