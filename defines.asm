BLACK = 0
WHITE = 1
RED = 2
CYAN = 3
PURPLE = 4
GREEN = 5
BLUE = 6
YELLOW = 7

KEY = 1
STAL = 2
BUSH = 3
WEB = 4
BELT = 5
PLATFORM = 6
BLOCK = 7
CRUMBLE = 8 ; to 15
EXIT = 16 ; to 19
SWITCH = 20
SWITCHED = 21
BLOCK2 = 91
PLATFORM2 = 92

RASTERLINE_PAL      = $66
RASTERLINE_NTSC     = $54


udg_base = $1800 ; 16 chars
exit_udgs = udg_base + 16*8
switch_udgs = exit_udgs + 4*8
guardian_udgs = switch_udgs + 2*8 ; 6 guardians x 6 chars = 36 chars
player_udg = guardian_udgs + 6*6*8 ; 6 chars starting @58
propfont_udg = player_udg + 8*8 ; 23 chars starting @68

SWITCH_CHR = 20
SWITCHED_CHR = 21
GUARDIAN_CHR = 22
PLAY_CHR = 58
HEAD_CHR = 64
SOLID_CHR = 65
BLOCK2_CHR = 91
PLATFORM2_CHR = 92

GUARDIAN_HORIZONTAL = 0
GUARDIAN_UNIDIRECTIONALHORIZONTAL = 1
GUARDIAN_EUGENE = 16
GUARDIAN_VERTICAL = 17
GUARDIAN_KONG = 18
GUARDIAN_SKYLAB = 19