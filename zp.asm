; zero page
tmp             = $02
arr             = $03
scr_ptr         = $05
col_ptr         = $07
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
map_ptr         = $15
dead            = $17
on_ground       = $18
key_count       = $19
udg_ptr         = $1a
play_udg        = $1c
newy            = $1f

hx              = $20
hy              = $21
hl              = $22
hr              = $23
hd              = $24
hc				= $25
ht				= $26

exitx           = $27
exity           = $28
lastxmove       = $29
was_on_ground   = $2a
inairtime       = $2b
men             = $2c
menx            = $2d
map             = $2e
hit_exit        = $2f
exit_col		= $30

arr3			= $31 ; (2 bytes)

rasterline      = $36
stickleft       = $37
stickright      = $38
stickup         = $39
stickfire       = $3a
stickcontribute = $3b
jumpIsPressed   = $3c
ckck
music_index     = $3d
music_delay     = $3e
music_note		= $3f ; (3 bytes)
music_mod       = $42 ; (3 bytes)
music_bit       = $45

hguardian_index = $46
vguardian_index = $47
guard_udg_off   = $48
guard_udg_index = $49

hguard_count    = $4a
vguard_count    = $4b

air             = $4c
air_ctr         = $4d

ts              = $50 ; start of temporaries

key_cols		= $54 ; 2*5

num_guardians   = $60
guardian_index  = $61
guardian_data   = $62 ; 6*8

key_adds        = $92 ; 2*5
belt_spd        = $9c

left_right_ctr  = $9d
crumble_ctr     = $9e
up_down_ctr     = $9f

player_overlap  = $a0 ; (6 bytes)
player_touch    = $a6 ; (48 bytes a6-d5)

score			= $e0 ; (3 bytes)
hi				= $e3 ; (3 bytes)

frame_ctr		= $e6

stringwidth     = $e8
stringindex     = $e9
stringstart     = $ea
stringxdiv		= $eb
stringxmod		= $ec
stringcur		= $ed
stringleft		= $ee
stringright		= $ef
stringrow		= $f0

switch_count    = $f1
remove_guardian = $f2
kong_dead       = $f3
skylab_frame    = $f4 ; (3 bytes)
vguard_frame    = $f7
hguard_frame	= $f8