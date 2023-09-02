; For counting
reset bytes

; WORK RAM
ORG $003000
DirectPage:

; scratch ram
; used for many various purposes
_0: skip 1 ;FLG_XY
_1: skip 1 ;FLG_XY
_2: skip 1 ;FLG_X
_3: skip 1 ;FLG_X
_4: skip 1 ;FLG_X
_5: skip 1 ;FLG_Y
_6: skip 1 ;FLG_XY
_7: skip 1 ;FLG_X
_8: skip 1 ;FLG_X
_9: skip 1
_A: skip 1 ;FLG_X
_B: skip 1
_C: skip 1 ;FLG_X
_D: skip 1
_E: skip 1
_F: skip 1
SA1_CALLFUNC_PTR: skip 3
SA1_EXECUTE_FUNC: skip 1
SA1_READY: skip 1
TEST_PASADO: skip 1
TEXT_IND: skip 2