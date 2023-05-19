strings_lo
    !byte <string_press_jump
	!byte <string_air
	!byte <string_score
	!byte <string_hi
	!byte <string_game
	!byte <string_over
strings_hi
    !byte >string_press_jump
	!byte >string_air
	!byte >string_score
	!byte >string_hi
	!byte >string_game
	!byte >string_over

STRINGPRESSJUMP = 0
STRINGAIR = 1
STRINGSCORE = 2
STRINGHI = 3
STRINGGAME = 4
STRINGOVER = 5

string_press_jump
    !byte GREEN
    !text "Press Jump",0
string_air
	!byte YELLOW
	!text "AIR", 0
string_score
	!byte YELLOW
	!text "SCORE", 0
string_hi
	!byte YELLOW
	!text "HI", 0
string_game
	!byte RED
	!text "Game", 0
string_over
	!byte RED
	!text "Over", 0