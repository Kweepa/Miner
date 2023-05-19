maptab
    !word map0, map1, map2, map3, map4, map5, map6, map7, map8, map9
	!word map10, map11, map12, map13, map14, map15, map16, map17, map18, map19

map0

; num types
    !byte 7

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

	; exit color, x, y
	!byte BLUE,20,14

	; exit graphic data
	!byte 255,255,146,73,182,219,255,255
	!byte 146,73,182,219,255,255,146,73
	!byte 182,219,255,255,146,73,182,219
	!byte 255,255,146,73,182,219,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,27,42,0,12,33,39,26,0,0,0

; num guardians
    !byte 1
    !byte 20,64,16,35,1,YELLOW,0 ; x,y,min,max,speed,col,type

; bg colour, player xy, belt speed
    !byte 10, 4, 112, -1
; guardian indices	
	!byte 0, -1

	!text "Central Cavern", 0

map1

    !byte 8
    
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

	; exit color, x, y
    !byte RED,20,14

	; exit graphic data
	!byte 255,255,146,73,146,73,146,73
	!byte 146,73,146,73,146,73,146,73
	!byte 146,73,146,73,146,73,146,73
	!byte 146,73,146,73,146,73,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 49,27,43,0,12,33,39,26,0,0,0

	; num guardians
    !byte 2
    !byte 20,32,0,47,1,YELLOW,0
    !byte 56,112,36,83,1,CYAN,0

	; bg colour, player xy, belt speed
    !byte 106, 4, 112, -1
	; guardian indices, guardian colors	
	!byte 1, -1

	!text "The Cold Room", 0

map2
    !byte 6

    !byte KEY,YELLOW,5
    !word 25,31,38,168,175

    !byte STAL,PURPLE,3
    !word 41,55,264

	; BUSH

	!byte WEB,PURPLE,2+128
	!word 33,198+(2<<9)

    !byte BELT,RED,1
    !word 1760

    !byte PLATFORM,CYAN,8
    !word 1024+132,1536+176,1024+195,260+1536,274+1536,289+1536,324+2560,11104

	; BLOCK

    !byte CRUMBLE,CYAN,1
    !word 135+9216

	; exit col, x, y
    !byte BLUE,20,12

	!byte 255,255,68,68,153,153,34,34
	!byte 34,34,153,153,68,68,68,68
	!byte 153,153,34,34,34,34,153,153
	!byte 68,68,68,68,153,153,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,8,0,5,14,28,0,29,0,0,0

; num guardians
    !byte 3
    !byte 36,32,0,35,-1,PURPLE,0
    !byte 48,32,40,83,1,RED,0
    !byte 48,112,0,59,-1,GREEN,0

; bg colour, player xy, belt speed
    !byte 10, 4, 112, -1
; guardian indices
	!byte 2, -1

    !text "The Menagerie", 0

map3
    !byte 6
    
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

	; exit col, x, y
	!byte BLUE,20,14

	; exit graphic data
	!byte 34,34,17,17,136,136,68,68
	!byte 34,34,17,17,136,136,68,68
	!byte 34,34,17,17,136,136,68,68
	!byte 34,34,17,17,136,136,68,68
    
	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,6,0,0,12,33,39,26,0,0,0

; num guardians
    !byte 2
    !byte 0,112,0,23,1,RED,0
    !byte 28,112,20,43,1,GREEN,0

; bg colour, player xy, belt speed
    !byte 10, 80, 112, 1
; guardian indices
	!byte 3, -1
	
    !text "Abandoned Uranium Workings", 0

map4
	!byte 8
	
    !byte KEY,YELLOW,5
    !word 22*2+21, 22*7+6, 22*8+21, 22*13+4, 22*13+6

    !byte STAL,PURPLE,1
    !word 22+14
	
	!byte BUSH,YELLOW,4
	!word 22*5+17, 22*8+15, 22*15+2, 22*15+17+(1<<9)

    !byte BELT,YELLOW,1
    !word 22*9+12+(7<<9)

    !byte PLATFORM,CYAN,9
    !word 22*6+(9<<9), 22*6+16+(2<<9), 22*7+20+(1<<9), 22*10+2+(7<<9), 22*12+1+(8<<9), 22*12+12+(5<<9)
	!word 22*12+21, 22*14, 22*16+(21<<9)
    
    !byte BLOCK,GREEN,3+128
    !word 22*13+5+(2<<9),22*14+9+(1<<9),22*14+12+(1<<9)

    !byte BLOCK,GREEN,2
    !word 22*15+13+(3<<9), 22*16+4+(12<<9)

    !byte CRUMBLE,GREEN,2
    !word 22*6+12+(3<<9), 22*12

	; exit col, x, y
	!byte WHITE,10,14

	; exit graphic data
	!byte 255,255,170,170,170,170,170,170
	!byte 170,170,170,170,170,170,170,170
	!byte 170,170,170,170,170,170,170,170
	!byte 170,170,170,170,170,170,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 50,3,42,0,16,33,39,26,0,0,0

; num guardians
    !byte 3
    !byte 27,32,0,27,-1,YELLOW,0
    !byte 8,64,8,27,1,BLACK,0
	!byte 40,8,8,96,1,WHITE,GUARDIAN_EUGENE

; bg colour, player xy, belt speed
    !byte 46, 0, 32, -1
; guardian indices
	!byte 4, 27
		
    !text "Eugene's Lair", 0

map5
	!byte 6

	!byte KEY,YELLOW,5
	!word 22*7+10,22*7+12,22*8+21,22*11,22*12+8

	!byte STAL,YELLOW,2
	!word 22*5+14,22*12+12

	!byte BUSH,PURPLE,1
	!word 22*13+2

	!byte BELT,CYAN,1
	!word 22*14+2+(2<<9)

	!byte PLATFORM,GREEN,11
	!word 22*10+(1<<9), 22*7+2, 22*6+5+(2<<9), 22*6+10+(1<<9), 22*6+14+(4<<9), 22*7+20+(1<<9)
	!word 22*11+5+(11<<9), 22*9+16+(3<<9), 22*13+20+(1<<9), 22*14+15+(1<<9), 22*16+(21<<9)

	!byte BLOCK,YELLOW,2+128
	!word 22*7+11+(1<<9), 22*11+11+(2<<9)

	; exit col, x, y
	!byte YELLOW,20,1

	; exit graphic data
	!byte 255,255,129,129,191,253,191,253
	!byte 176,13,176,13,176,13,240,15
	!byte 240,15,176,13,176,13,176,13
	!byte 191,253,191,253,129,129,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,40,42,0,12,30,39,0,0,0,0

; guardians
	!byte 4
	!byte 16,72,16,35,1,YELLOW,0
	!byte 40,72,40,59,1,PURPLE,0
	!byte 20,112,20,55,1,CYAN,0
	!byte 68,112,68,83,1,YELLOW,0

	; bg color, playerxy, belt speed
	!byte 10,44,32,-1

	; guardian indices
	!byte 5,0

    !text "Processing Plant", 0

map6
	!byte 7

	!byte BLOCK, CYAN, 3
	!word 22+9+(12<<9), 22*13+9+(2<<9), 22*16+9+(12<<9)

	!byte BLOCK, CYAN, 2+128
	!word 22*4+11+(9<<9), 22*13+9+(3<<9)

	!byte PLATFORM, YELLOW, 8
	!word 22*4+10, 22*6+9+(1<<9), 22*7+(1<<9), 22*9, 22*10+9+(1<<9), 22*11+(6<<9)
	!word 22*14+5+(1<<9), 22*16+(8<<9)

	!byte BELT, GREEN, 1
	!word 22*6+4+(2<<9)

	!byte CRUMBLE, RED, 10
	!word 22*4+12+(9<<9), 22*5+12+(9<<9), 22*6+12+(9<<9), 22*7+12+(9<<9), 22*8+12+(9<<9)
	!word 22*9+12+(9<<9), 22*10+12+(9<<9), 22*11+12+(9<<9), 22*12+12+(9<<9), 22*13+12+(9<<9)

	!byte KEY, YELLOW, 5
	!word 22*4+21, 22*7+14, 22*8+19, 22*11+13, 22*12+21

	!byte BUSH, YELLOW, 4
	!word 22*6+20, 22*9+16, 22*11+20, 22*13+16

	; exit col, x, y
	!byte PURPLE, 10, 14

	; exit graphic data
	!byte 255,255,129,129,129,129,129,129
	!byte 129,129,129,129,129,129,255,255
	!byte 255,255,129,129,129,129,129,129
	!byte 129,129,129,129,129,129,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,0,9,0,12,33,39,25,0,0,0

	; guardians
	!byte 3
	!byte 40,16,40,83,1,CYAN,0
	!byte 27,72,4,23,-1,PURPLE,0
	!byte 48,112,48,83,1,YELLOW,0

	; bg color, playerxy, belt speed
	!byte 13,4,112,1

	; guardian indices
	!byte 6,0

    !text "The Vat", 0

map7
	!byte 7
	
	!byte STAL, CYAN, 2
	!word 22+1,22+7

	!byte SWITCH, YELLOW, 2
	!word 22+4,22+13

	!byte KEY, YELLOW, 4
	!word 22*3+8, 22*7+9, 22*9+1, 22*14+20

	!byte BLOCK, YELLOW, 4+128
	!word 22+12+(8<<9), 22*9+12+(6<<9), 22+15+(1<<9), 22*14+9+(1<<9)

	!byte PLATFORM, RED, 19
	!word 22*3+10+(1<<9), 22*3+20+(1<<9), 22*6+(2<<9), 22*6+6+(3<<9), 22*6+13+(1<<9)
	!word 22*7+16+(1<<9), 22*8+19, 22*7+21, 22*8+1+(1<<9), 22*9+5+(1<<9), 22*11+8+(1<<9)
	!word 22*12+6, 22*13+3+(1<<9), 22*10+13+(4<<9), 22*11+19+(2<<9), 22*13+16+(1<<9)
	!word 22*14+13+(1<<9), 22*16+(21<<9), 22*11

	!byte BUSH, GREEN, 1
	!word 22*15+16

	!byte BELT, GREEN, 1
	!word 22*14+7+(1<<9)

	;exit col, x, y
	!byte YELLOW, 10, 14

	; exit graphic data
	!byte 255,255,128,1,192,3,160,5
	!byte 144,9,200,19,164,37,146,73
	!byte 201,147,164,37,146,73,201,147
	!byte 164,37,201,147,146,73,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 51,3,42,0,13,33,39,0,22,0,0

	; guardians
	!byte 4
	!byte 52,64,52,67,1,CYAN,0
	!byte 28,96,28,43,1,PURPLE,0
	!byte 23,112,0,23,-1,GREEN,0
	!byte 40,8,40,40,0,GREEN,18

	; bg color, player xy, belt speed
	!byte 10, 4, 112, 1

	; guardian indices
	!byte 8, 7

    !text "Miner Willy Meets the Kong Beast", 0

map8
	!byte 3
	
    !byte KEY,YELLOW,1
    !word 22*2+11

    !byte BELT,GREEN,1
    !word 22*9+8+(5<<9)

    !byte PLATFORM,YELLOW,18
    !word 22*6+(1<<9), 22*6+4+(1<<9), 22*6+8+(5<<9), 22*6+16+(1<<9), 22*6+20, 22*8+21
	!word 22*9+1, 22*9+4+(1<<9), 22*10+16+(1<<9), 22*10+20
	!word 22*11, 22*13+1, 22*13+4+(1<<9), 22*13+8+(5<<9), 22*13+16+(1<<9), 22*13+20, 22*14+21
	!word 22*16+(21<<9)
    
	; exit col, x, y
	!byte BLUE,0,1

	; exit graphic data
	!byte 255,255,128,1,129,129,130,65
	!byte 132,33,136,17,144,9,161,133
	!byte 161,133,144,9,136,17,132,33
	!byte 130,65,129,129,128,1,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,0,0,0,11,33,0,0,0,0,0

; num guardians
    !byte 6
    !byte 32,32,32,51,1,GREEN,0
    !byte 44,88,32,51,1,CYAN,0
	!byte 8,16,16,104,1,PURPLE,17
	!byte 24,16,16,104,2,GREEN,17
	!byte 56,16,16,104,2,CYAN,17
	!byte 72,16,16,104,1,RED,17

; bg colour, player xy, belt speed
    !byte 14, 0, 112, 1
; guardian indices
	!byte 10, 9
		
    !text "Wacky Amoebatrons", 0

map9

	!byte 6

	!byte BUSH,GREEN,8
	!word 22+7, 22+13, 22+15, 22*2+16, 22*4+1, 22*10, 22*11+21, 22*12+16

	!byte PLATFORM, GREEN, 16
	!word 22+9+(1<<9), 22+16+(5<<9), 22*3+(3<<9), 22*3+19+(2<<9), 22*5+12+(2<<9)
	!word 22*6+6, 22*6+17+(4<<9), 22*7+(2<<9), 22*8+12+(4<<9), 22*9+(3<<9)
	!word 22*10+7+(3<<9), 22*10+20+(1<<9), 22*11+(2<<9), 22*11+12+(4<<9), 22*14+(1<<9), 22*14+20+(1<<9)

	!byte KEY, RED, 5
	!word 22*2+9, 22*2+21, 22*3+16, 22*7+8, 22*9+13

	!byte CRUMBLE, RED, 4
	!word 22*6+7+(3<<9), 22*8+18+(1<<9), 22*11+3+(1<<9), 22*12+17+(1<<9)

	!byte BLOCK, CYAN, 2
	!word 22*13+6+(6<<9), 22*16+(21<<9)

	!byte BLOCK2, RED, 1+128
	!word 22+11+(11<<9)

	; exit col, x, y
	!byte RED, 8, 14

	; exit graphic data
	!byte 255,255,248,143,136,145,170,145
	!byte 170,149,138,133,144,145,213,185
	!byte 213,85,209,69,137,57,137,3
	!byte 168,171,170,171,138,137,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 52,0,44,46,0,2,32,17,0,46,0

	; guardians
	!byte 4
	!byte 52,48,48,63,1,CYAN,0
	!byte 28,64,28,39,1,YELLOW,0
	!byte 36,88,24,39,1,RED,0
	!byte 24,112,8,75,1,PURPLE,0

	; bg colour, player xy, belt speed
    !byte 10, 0, 40, 1
	
	; guardian indices
	!byte 11,0

	!text "The Endorian Forest", 0

map10
	!byte 8

	!byte BLOCK,WHITE,1
	!word 22+(4<<9)

	!byte WEB,RED,4+128
	!word 22+13, 22*7+16+(2<<9), 22*11+9+(1<<9), 22*11+13

	!byte BUSH,YELLOW,4
	!word 22*2+13, 22*10+16, 22*13+9, 22*12+13

	!byte KEY,RED,5
	!word 22+16, 22*2+21, 22*5, 22*7+13, 22*14+21

	!byte PLATFORM,BLUE,13
	!word 22*4+(2<<9), 22*6+3+(3<<9), 22*6+9+(8<<9), 22*7+21, 22*9, 22*9+21
	!word 22*10+7+(6<<9), 22*11+20, 22*12+5, 22*13+20+(1<<9), 22*14, 22*14+16+(1<<9), 22*16+(21<<9)

	!byte BLOCK2,CYAN,1
	!word 22*6+12+(3<<9)

	!byte CRUMBLE,BLUE,1
	!word 22*12+3+(1<<9)

	!byte BELT,YELLOW,1
	!word 22*9+4

	; exit col, xy
	!byte YELLOW, 0, 2

	; exit graphic data
	!byte 255,255,218,171,234,107,255,255
	!byte 144,9,144,9,255,255,144,9
	!byte 144,9,255,255,144,9,144,9
	!byte 255,255,144,9,144,9,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 53,0,7,5,19,33,10,26,0,36,0

	; guardians
	!byte 6
	!byte 4,40,40,104,2,GREEN,17
	!byte 28,16,8,64,2,PURPLE,17
	!byte 56,56,56,104,2,YELLOW,17
	!byte 72,24,8,104,-2,RED,17
	!byte 40,32,36,67,1,YELLOW,0
	; !byte 40,52,40,47,1,GREEN,0 ; removed this one since the engine is too slow.
	!byte 40,112,12,52,-1,RED,0

	; bg colour, player xy, belt speed
    !byte 10, 8, 16, -1
	
	; guardian indices
	!byte 13,12

	!text "Attack of the Mutant Telephones", 0

map11

	!byte 9

	!byte STAL,CYAN,2
	!word 22+1, 22+7

	!byte SWITCH,YELLOW,2
	!word 22+4, 22+13

	!byte PLATFORM,PURPLE,13
	!word 22*6+(1<<9), 22*8+4, 22*9+1, 22*10+7+(1<<9), 22*11+4, 22*13+(4<<9), 22*14+7+(1<<9)
	!word 22*6+18, 22*7+21, 22*9+16+(5<<9), 22*11+13+(1<<9), 22*12+18, 22*16+(21<<9)

	!byte BLOCK,CYAN,3
	!word 22+12, 22+15, 22*16+9+(3<<9)

	!byte BLOCK,CYAN,3+128
	!word 22*6+9+(4<<9), 22*6+12+(10<<9), 22*14+9+(1<<9)

	!byte CRUMBLE,PURPLE,3
	!word 22*3+10+(1<<9), 22*6+6+(2<<9), 22*6+13+(4<<9)

	!byte KEY,RED,5
	!word 22*4+10, 22*6+19, 22*7, 22*8+11, 22*14+20

	!byte BUSH,GREEN,2
	!word 22*13+16, 22*13+19

	!byte BELT,YELLOW,1
	!word 22*14+13+(6<<9)

	; exit col, x, y
	!byte YELLOW,10,14

	; exit graphic data
	!byte 255,255,128,1,143,241,143,241
	!byte 143,241,143,241,143,241,140,49
	!byte 140,49,143,241,143,241,143,241
	!byte 143,241,143,241,128,1,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 51,3,42,0,13,33,39,26,22,0,0

	; guardians
	!byte 4
	!byte 64,56,64,79,1,CYAN,0
	!byte 28,96,28,43,1,PURPLE,0
	!byte 23,112,0,23,-1,GREEN,0
	!byte 40,8,40,40,0,GREEN,18

	; bg color, player xy, belt speed
	!byte 10, 4, 112, 1

	; guardian indices
	!byte 8, 7

    !text "Return of the Alien Kong Beast", 0

map12

	!byte 5

	!byte BLOCK,RED,1
	!word 22+(21<<9)

	!byte PLATFORM,CYAN,13
	!word 22*4+5+(12<<9), 22*4+19+(2<<9)
	!word 22*7+5+(5<<9), 22*7+12+(3<<9), 22*7+17+(2<<9), 22*7+21
	!word 22*10+5+(2<<9), 22*10+9+(12<<9)
	!word 22*13+5+(4<<9), 22*13+11+(3<<9), 22*13+16+(2<<9), 22*13+20+(1<<9)
	!word 22*16+(21<<9)

	!byte KEY,RED,5
	!word 22*4+18, 22*7+7, 22*10+12, 22*10+17, 22*13+7

	!byte PLATFORM2,YELLOW,2+128
	!word 22*2+2+(8<<9), 22*10+2+(5<<9)

	!byte BELT,GREEN,1
	!word 22*16+2+(17<<9)

	; exit col, x, y
	!byte WHITE,0,14

	; exit graphic data
	!byte 3,192,7,224,15,240,9,144
	!byte 9,144,7,224,5,160,2,64
	!byte 97,134,248,31,254,127,5,224
	!byte 7,160,254,127,248,31,96,6

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 54,0,0,0,11,31,47,0,0,0,20

	; guardians
	!byte 5
	!byte 20,16,20,83,1,PURPLE,0
	!byte 40,40,20,83,1,GREEN,0
	!byte 60,64,32,79,-1,YELLOW,0
	!byte 48,88,20,83,-1,RED,0
	!byte 12,16,16,96,2,WHITE,17

	; bg color, player xy, belt speed
	!byte 14, 76, 112, -1

	; guardian indices
	!byte 15, 14

    !text "Ore Refinery", 0

map13
	
	!byte 5

	!byte PLATFORM,GREEN,11
	!word 22*12, 22*8+2, 22*10+4, 22*14+4, 22*7+6, 22*10+8, 22*6+10, 22*7+14, 22*10+16, 22*12+18, 22*9+20

	!byte PLATFORM2,GREEN,11
	!word 22*12+1, 22*8+3, 22*10+5, 22*14+5, 22*7+7, 22*10+9, 22*6+11, 22*7+15, 22*10+17, 22*12+19, 22*9+21

	!byte KEY,RED,4
	!word 22*3+16,22*8+11,22*10+2,22*10+20

	!byte BELT,PURPLE,1
	!word 22*12+10+(5<<9)

	!byte BLOCK,CYAN,1
	!word 22*16+(21<<9)

	; exit col, x, y
	!byte YELLOW,10,1

	; exit graphic data
	!byte 255,255,255,255,252,63,248,31
	!byte 240,15,224,7,193,131,194,67
	!byte 194,67,193,131,224,7,240,15
	!byte 248,31,252,63,255,255,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 55,0,0,0,11,37,1,0,0,0,38

	; guardians
	!byte 3
	!byte 0,8,8,40,4,WHITE,GUARDIAN_SKYLAB
	!byte 32,8,8,40,1,CYAN,GUARDIAN_SKYLAB
	!byte 72,8,8,40,2,YELLOW,GUARDIAN_SKYLAB

	; bg color, player xy, belt speed
	!byte 111, 76, 112, -1

	; guardian indices
	!byte 17,16

	!text "Skylab Landing Bay", 0

map14

	!byte 8

	!byte BLOCK,WHITE,1
	!word 22+4+(17<<9)

	!byte PLATFORM2,YELLOW,4+128
	!word 22+20+(8<<9), 22+21+(8<<9), 22*9+20+(7<<9), 22*9+21+(7<<9)

	!byte KEY,RED,3
	!word 22*3+17, 22*7+8, 22*15+18

	!byte BELT,CYAN,1
	!word 22*4+5+(10<<9)

	!byte PLATFORM,BLUE,14
	!word 22*6+(2<<9), 22*9+1+(1<<9), 22*11, 22*13+3+(1<<9), 22*16+(21<<9)
	!word 22*8+8+(1<<9), 22*11+8+(1<<9), 22*14+8+(1<<9)
	!word 22*9+12+(1<<9), 22*12+12+(1<<9)
	!word 22*4+16+(3<<9), 22*7+17, 22*10+18, 22*13+16+(1<<9)

	!byte CRUMBLE,BLUE,1
	!word 22*8+4
	
	!byte WEB,RED,2+128
	!word 22*5+5, 22*5+19+(5<<9)

	!byte BUSH,YELLOW,2
	!word 22*6+5, 22*11+19

	; exit col, x, y
	!byte RED,0,4

	; exit graphic data
	!byte 255,255,128,1,128,1,128,1
	!byte 128,1,136,1,170,1,156,61
	!byte 255,71,156,1,170,1,136,1
	!byte 128,1,128,1,128,1,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 56,0,7,5,19,34,10,26,0,0,35

	; guardians
	!byte 4
	!byte 48,112,40,68,1,CYAN,GUARDIAN_HORIZONTAL
	!byte 24,48,44,112,1,YELLOW,GUARDIAN_VERTICAL
	!byte 40,72,44,112,1,WHITE,GUARDIAN_VERTICAL
	!byte 56,88,40,112,-2,GREEN,GUARDIAN_VERTICAL

	; bg color, player xy, belt speed
	!byte 10, 4, 112, -1

	; guardian indices
	!byte 19,18

	!text "The Bank", 0

map15

	!byte 7
	
	!byte KEY,RED,4
	!word 22,22*3+21,22*8+7,22*11+12

	!byte PLATFORM,RED,11
	!word 22*6, 22*6+2, 22*6+14+(1<<9), 22*8+1, 22*8+16+(5<<9)
	!word 22*12+8, 22*12+18, 22*13+(5<<9), 22*14+14, 22*14+18, 22*16+(21<<9)

	!byte BLOCK,CYAN,3+128
	!word 22*6+5+(3<<9), 22*6+8+(3<<9), 22*8+9+(1<<9)

	!byte BLOCK,CYAN,1
	!word 22*12+6+(1<<0)

	!byte CRUMBLE,RED,1
	!word 22*10+(1<<9)

	!byte BELT,YELLOW,1
	!word 22*10+2+(16<<9)

	!byte STAL,GREEN,1
	!word 22*15+16+(1<<9)

	; exit col, x, y
	!byte PURPLE,6,6

	; exit graphic data
	!byte 255,255,129,129,129,129,255,255
	!byte 129,129,129,129,255,255,129,129
	!byte 129,129,255,255,129,129,129,129
	!byte 255,255,129,129,129,129,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 57,43,0,0,13,33,45,26,0,0,0

	; guardians
	!byte 4
	!byte 17*4,6*8,16*4,21*4-1,1,CYAN,GUARDIAN_HORIZONTAL
	!byte 10*4,8*8,10*4,15*4-1,1,PURPLE,GUARDIAN_HORIZONTAL
	!byte 0,11*8,0,5*4-1,1,YELLOW,GUARDIAN_HORIZONTAL
	!byte 7*4,14*8,0,13*4-1,1,GREEN,GUARDIAN_HORIZONTAL

	; bg color, player xy, belt speed
	!byte 10, 4, 112, -1

	; guardian indices
	!byte 20,0

	!text "The Sixteenth Cavern", 0

map16

	!byte 8

	!byte CRUMBLE,GREEN,8
	!word 22*6+(21<<9),22*7+(21<<9),22*8+(21<<9),22*9+(21<<9),22*10+(21<<9),22*11+(21<<9),22*12+(21<<9),22*13+(21<<9)

	!byte 0,WHITE,8+128
	!word 22*9+2+(4<<9),22*9+3+(4<<9), 22*6+7+(7<<9),22*6+8+(7<<9), 22*6+13+(4<<9),22*6+14+(4<<9), 22*6+18+(7<<9),22*6+19+(7<<9)

	!byte BLOCK,YELLOW,1
	!word 22+20+(1<<9)

	!byte BUSH,YELLOW,4
	!word 22*5+3, 22*5+6, 22*5+10, 22*5+16

	!byte PLATFORM,GREEN,4
	!word 22*6+(1<<9), 22*6+20+(1<<9), 22*15+19+(2<<9), 22*16+(21<<9)

	!byte STAL,BLUE,4
	!word 22*7+2, 22*8+17, 22*11+15, 22*12+6

	!byte KEY,RED,5
	!word 22*6+16, 22*8+11, 22*9, 22*11+13, 22*12+17

	!byte BELT,GREEN,1
	!word 22*9+11+(1<<9)

	; exit col, x, y
	!byte CYAN,20,2

	; exit graphic data
	!byte 255,255,128,1,191,253,160,5
	!byte 165,165,165,165,165,165,165,165
	!byte 165,165,165,165,175,245,165,165
	!byte 165,165,165,165,165,165,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,41,42,0,14,33,23,25,0,0,0

	; guardians
	!byte 6
	!byte 4*4,14*8,4*4,8*4-1,1,RED,GUARDIAN_HORIZONTAL
	!byte 10*4,14*8,9*4,18*4-1,1,CYAN,GUARDIAN_HORIZONTAL
	!byte 2*4,72,72,110,1,BLUE,GUARDIAN_VERTICAL
	!byte 7*4,72,8,96,-2,YELLOW,GUARDIAN_VERTICAL
	!byte 13*4,56,8,64,1,WHITE,GUARDIAN_VERTICAL
	!byte 18*4,16,12,96,2,PURPLE,GUARDIAN_VERTICAL

	; bg color, player xy, belt speed
	!byte 10, 4, 4*8, 1

	; guardian indices
	!byte 22,21

	!text "The Warehouse", 0

map17

	!byte 2
	
    !byte KEY,RED,1
    !word 22*2+10

    !byte PLATFORM,RED,19
    !word 22*6+20+(1<<9), 22*6+16+(1<<9), 22*6+8+(5<<9), 22*6+4+(1<<9), 22*6+1, 22*8
	!word 22*9+20, 22*9+16+(1<<9), 22*9+8+(5<<9), 22*10+4+(1<<9), 22*10+1
	!word 22*11+21, 22*13+20, 22*13+16+(1<<9), 22*13+8+(5<<9), 22*13+4+(1<<9), 22*13+1, 22*14
	!word 22*16+(21<<9)
    
	; exit col, x, y
	!byte YELLOW,20,1

	; exit graphic data
	!byte 255,255,128,1,176,13,160,5
	!byte 170,85,170,85,170,85,170,85
	!byte 170,85,170,85,170,85,170,85
	!byte 160,5,176,13,128,1,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,0,0,0,11,33,0,0,0,0,0

; num guardians
    !byte 6
    !byte 32,56,32,48,1,PURPLE,0
    !byte 44,88,32,48,1,CYAN,0
	!byte 8,16,16,104,1,PURPLE,GUARDIAN_VERTICAL
	!byte 24,16,16,104,2,GREEN,GUARDIAN_VERTICAL
	!byte 56,16,16,104,4,CYAN,GUARDIAN_VERTICAL
	!byte 72,16,16,104,1,YELLOW,GUARDIAN_VERTICAL

; bg colour, player xy, belt speed
    !byte 14, 80, 112, -1
; guardian indices
	!byte 10, 23

	!text "Amoebatrons' Revenge", 0

map18

	!byte 4
	
	!byte KEY,RED,3
	!word 22*2+21, 22*6, 22*13+21

	!byte PLATFORM,BLACK,12
	!word 22*6+1, 22*6+5+(3<<9), 22*6+17+(4<<9), 22*8+12+(2<<9), 22*9, 22*9+8+(1<<9), 22*9+17+(4<<9)
	!word 22*11+13, 22*12+(1<<9), 22*12+17+(4<<9), 22*13+8+(4<<9), 22*16+2+(19<<9)
	
	!byte BLOCK,RED,4
	!word 22+(1<<9), 22*15+(1<<9), 22*16+(1<<9), 22*16+16

	!byte BELT,YELLOW,1
	!word 22*13+4+(1<<9)

	; exit col, x, y
	!byte YELLOW,0,2

	; exit graphic data
	!byte 255,255,128,1,191,253,160,5
	!byte 175,245,168,21,171,213,170,85
	!byte 170,85,171,213,168,21,175,245
	!byte 160,5,191,253,128,1,255,255

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,0,0,0,12,33,39,0,0,0,0

; num guardians
    !byte 6
    !byte 17*4,4*8,16*4,20*4+3,1,PURPLE,GUARDIAN_UNIDIRECTIONALHORIZONTAL
    !byte 19*4,7*8,16*4,20*4,1,BLUE,GUARDIAN_UNIDIRECTIONALHORIZONTAL
	!byte 10*4,14*8,4*4,20*4+3,1,RED,GUARDIAN_UNIDIRECTIONALHORIZONTAL
	!byte 2*4,72,8,112,4,PURPLE,GUARDIAN_VERTICAL
	!byte 6*4,64,56,112,-2,RED,GUARDIAN_VERTICAL
	!byte 10*4,88,12,88,-1,BLUE,GUARDIAN_VERTICAL

; bg colour, player xy, belt speed
    !byte 92, 8*4+2, 11*8, 1
; guardian indices
	!byte 25, 24

	!text "Solar Power Generator", 0	

map19
	!byte 7

	!byte BLOCK,GREEN,4
	!word 22*4+12+(9<<9), 22*5+(21<<9), 22*6+(11<<9), 22*7+(11<<9)
	
	!byte BLOCK,GREEN,2+128
	!word 22*4+14+(3<<9), 22*4+11+(2<<9)

	!byte KEY,RED,5
	!word 22*6+16, 22*7+21, 22*12+5, 22*12+9, 22*12+13

	!byte BELT,CYAN,1
	!word 22*11+(15<<9)

	!byte PLATFORM,RED,5
	!word 22*16+(21<<9), 22*14+2, 22*13, 22*12+20, 22*9+21

	!byte CRUMBLE,RED,1
	!word 22*11+18

	!byte BUSH,GREEN,4
	!word 22*12+4, 22*12+7, 22*12+11, 22*12+15
	
	; exit col, x, y
	!byte PURPLE,12,6

	; exit graphic data
	!byte 0,0,7,224,24,24,35,196
	!byte 68,34,72,18,72,18,72,18
	!byte 68,34,34,68,26,88,74,82
	!byte 122,94,66,66,126,126,0,0

	; block indices: key, stal, bush, web, belt, platform, block, crumble, switch, block2, platform2
	!byte 48,0,7,0,12,33,39,26,0,0,0

; num guardians
    !byte 2
    !byte 3*4,14*8,3*4,20*4+3,1,YELLOW,GUARDIAN_HORIZONTAL
	!byte 16*4,56,48,111,1,WHITE,GUARDIAN_VERTICAL

; bg colour, player xy, belt speed
    !byte 10, 20*4, 14*8, 1
; guardian indices
	!byte 26, 14

	!text "The Final Barrier", 0

DrawFinalBackground
	lda map
	cmp #19
	beq +
	rts
+
	ldx #(22*5-1)
-
	lda happy_chars,x
	clc
	adc #96
	sta screen_base,x
	lda happy_cols,x
	sta color_base,x
	dex
	bpl -
	rts

happy_chars	
	!byte 0,1,2,3,4,4,4,4,4,5,6,7,4,4,8,1,1,9,4,4,4,4
	!byte 10,1,11,12,13,14,15,16,17,18,19,20,21,4,1,22,22,1,4,4,23,24
	!byte 25,26,27,1,28,29,30,31,1,32,4,4,33,33,1,22,22,1,34,34,35,36
	!byte 37,4,38,39,40,41,42,43,44,45,4,4,46,46,1,1,1,1,47,47,48,49
	!byte 50,51,52,53,54,1,1,55,56,57,58,59,1,1,1,1,1,1,1,1,1,1
happy_cols
	!byte 5,5,5,5,1,1,1,1,1,1,1,1,1,1,7,7,7,7,1,1,1,1
	!byte 2,5,5,7,7,7,7,7,7,1,1,1,1,1,1,0,0,1,1,1,2,2
	!byte 2,2,7,7,7,7,7,7,7,7,1,1,7,4,1,0,0,1,1,1,2,2
	!byte 2,2,7,7,7,7,7,7,7,7,1,1,5,5,1,1,1,1,1,1,0,2
	!byte 2,5,7,7,7,7,7,7,7,7,5,5,5,5,5,5,5,5,5,5,5,5
