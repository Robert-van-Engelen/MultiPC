; multipc.asm - a BASIC program switcher
; Author: Dr. Robert A van Engelen, 2021
; License: BSD-3 open source
; Requires: AS61860 http://shop-pdp.net/ashtml/asxxxx.php
;
; PC-1350 with 16K RAM CARD:
; CALL 8240,NEW	delete all programs (to initialize after loading)
; CALL 8240	display the 10 programs slots
; CALL 8240,0	switch to program #0
; CALL 8240,1	switch to program #1
; .... ......	...
; CALL 8240,9	switch to program #9
;
; Each of the 10 programs can be edited, CLOADed, MERGEd or CHAINed.
; Switching between programs does not clear any variables.
; All programs reside on the RAM card and the RAM card can be swapped.

.area	PROGRAM (REL)

.include "target.asm"
.include "regs.asm"

KW_NEW	= 0xb1			; NEW token used by all S-BASIC SHARP machines

;	location of the code depends on the machine and RAM cards
.globl	RAM_BASIC

.radix	D

switcher::
	IXL			; parse ',' after CALL
	CPIA ',
	JPNZ sw_display		; if not ',' then display program slots
	IXL			; read the program digit
	CAL INT_ROM_SAVEX	; [CALL BASIC rtn @dr <- X] store X to return to BASIC
	PTC (1$-.-7)/3,INT_ROM_LOADX	; [X <- CALL BASIC rtn @dr] restore X
	DTC
	.case	KW_NEW,	sw_new
	.default	1$
1$:	SBIA '0			; A <- A - '0'
	JRCP sw_error_9		; if < 0 then ERROR 9
	CPIA 10
	JRNCP sw_error_9	; if > 9 then ERROR 9
	; FALL THROUGH		; switch to program A

; ------------------------------------------------------------------------------
; switch to program A
; changes I,A,B,X,Y,K,L,M,N,T,U,V,W
; ------------------------------------------------------------------------------

sw_switch:
	LIDP sw_active
	LP REG_B
	MVMD			; B <- (sw_active)
	CPMA
	JRZP sw_return		; if A == (sw_active) then return

;	update current active program size in the table, which may have become
;	stale when the program was edited or otherwise was changed;
;	the actual program size is (BASIC_END) - (BASIC_START)

	PUSH			; save program activation A
	LP REG_A
	LIDP BASIC_START_L
	MVBD			; BA <- (BASIC_START)
	LP REG_Y
	LIDP BASIC_END_L
	MVBD			; Y <- (BASIC_END)
	LP REG_Y
	SBB			; Y <- (BASIC_END) - (BASIC_START)
	LIDP sw_active
	LDD			; A <- current active program
	CALL sw_table_cell	; X <- sw_table-1 + 4*A
	IX
	IX
	IX
	LP REG_Y
	EXBD			; (sw_table+2 + 4*A) <-> (BASIC_END) - (BASIC_START)
	POP			; restore program activation A

;	rotate program A to the top; this rotates all programs located in
;	memory above A down, including the current active program on top

	LIDP sw_active
	STD			; activate program A
	CALL sw_get_prog	; BA <- start of activated program A, X <- size of activated program A
	LP REG_Y
	LIQ REG_X
	MVB			; Y <- X
	LP REG_Y
	ADB			; Y <- Y + BA = end of activated program A
	LP REG_X
	LIDP BASIC_END_L
	MVBD			; X <- (BASIC_END)
	LP REG_X
	SBB			; X <- (BASIC_END) - start of activated program A
	LP REG_A
	LIQ REG_X
	EXB			; BA <-> X
	CALL blk_swap		; swap memory block (X..Y-1) with block (Y..X+BA-1)

;	update table program pointers >= previous end of activated program A,
;	to point further down by the size of activated program A

	CALL sw_get_active_prog	; BA <- previous start of activated program A, X <- size of activated program A
	LP REG_M
	LIQ REG_X
	MVB			; NM <- X = size of activated program A
	LP REG_X
	ADB			; X <- X + BA = previous end of activated program A
	LP REG_Y
	LIDP sw_table_ptr
	MVBD			; Y <- sw_table-1
	LIA 10-1		; to loop 10 times
	PUSH
1$:	LP REG_T
	IY
	MVBD			;   TU <- (++Y)
	LP REG_A
	LIQ REG_X
	MVB			;   BA <- X
	LP REG_T
	SBB			;   TU <- TU - BA
	JRCP 2$			;   if (Y) >= X then
	DECP
	ADB			;     restore TU = (Y)
	LP REG_A
	LIQ REG_M
	MVB			;     BA <- NM
	LP REG_T
	SBB			;     TU <- TU - NM
	DY
	IY
	LP REG_T
	EXBD			;     (Y) <-> TU
2$:	IY
	IY
	IY			;   Y <- next table cell
	LOOP 1$			; loop

;	update activated program start to (BASIC_END) - size of program A,
;	since the activated program is moved to the top

	LP REG_Y
	LIDP BASIC_END_L
	MVBD			; Y <- (BASIC_END)
	LP REG_A
	LIQ REG_M
	MVB			; BA <- NM = size of activated program A
	LP REG_Y
	SBB			; Y <- (BASIC_END) - size of activated program A = new start of activated program A
	LIDP sw_active
	LDD
	CALL sw_table_cell	; X <- sw_table-1 + 4*A
	IX
	LP REG_Y
	EXBD			; (sw_table + 4*(sw_active)) <-> Y
	; FALL THROUGH

; ------------------------------------------------------------------------------
; set BASIC START and MERGE to the active program (BASIC END is unchanged)
; changes A,B,X,Y
; ------------------------------------------------------------------------------

sw_set_basic:
	CALL sw_get_active_prog	; BA <- start of program A, X <- size of program A
	LP REG_X
	LIQ REG_A
	MVB			; X <- BA = start of program A
	LIDP BASIC_START_L
	LP REG_A
	EXBD			; (BASIC_START) <-> BA
	LP REG_A
	LIQ REG_X
	MVB			; BA <- X = start of program A
	LIDP RAM_BASIC_START_L
	LP REG_A
	EXBD			; (RAM_BASIC_START) <-> BA

sw_next_prog1:			; repeat
	LP REG_Y
	LIQ REG_X
	MVB			;   Y <- X = position at 0xff marker
	LIB 0

sw_next_prog2:			;   repeat
	IXL			;     get line number MSB
	INCA			;     compare to 0xff marker
	JRZP sw_at_marker	;     if marker then check if program end
	IX			;     skip line number LSB
	IXL			;     A <- line length
	LP REG_X		;     add line length to X
	ADB
	JRM sw_next_prog2	;   loop

sw_at_marker:
	LP REG_A
	LIDP BASIC_END_L
	MVBD			;   BA <- (BASIC_END)
	;LP REG_X		;   assert P == REG_X
	SBB
	DECP
	ADB			;   compare X - (BASIC_END)
	JRCM sw_next_prog1	; loop until X >= (BASIC_END)
	LP REG_A
	LIQ REG_Y
	MVB			; BA <- Y
	LIDP BASIC_MERGE_L
	LP REG_Y
	EXBD			; (BASIC_MERGE) <-> Y
	LIDP RAM_BASIC_MERGE_L
	LP REG_A
	EXBD			; (RAM_BASIC_MERGE) <-> BA

;	reset the location that the cursor shows in PRO mode:

	JP 0x1530		; (0x6f1c) <- (BASIC_MERGE)

; ------------------------------------------------------------------------------
; error
; ------------------------------------------------------------------------------

sw_error_9:
	LIA 9			; A <- ERROR 9

sw_error:
	LP 0x34
	EXAM			; (0x34) <- error code A
	POP
	POP			; POP jump table return address
	POP
	POP			; POP BASIC CALL return address to return error
	;LIA 0x58
	;STR			; set stack pointer to 0x58 to bypass CALL
	SC			; set carry to report error
	JP INT_ROM_LOADX	; [X <- CALL BASIC rtn @dr]

; ------------------------------------------------------------------------------
; get active program start in BA and size in X
; changes A,B,X
; ------------------------------------------------------------------------------

sw_get_active_prog:
	LIDP sw_active
	LDD
	; FALL THROUGH

; ------------------------------------------------------------------------------
; get program A start in BA and size in X
; changes A,B,X
; ------------------------------------------------------------------------------

sw_get_prog:
	CALL sw_table_cell	; X <- sw_table-1 + 4*A
	LII 4-1
	LP REG_A
	IX
	MVWD			; BA <- (sw_table + 4*A), X <- (sw_table + 4*A + 2)
sw_return:
	RTN

; ------------------------------------------------------------------------------
; get table cell address of program A in X such that X = sw_table-1 + 4*A
; changes A,B,X
; ------------------------------------------------------------------------------

sw_table_cell:
	LP REG_X
	LIDP sw_table_ptr
	MVBD			; X <- sw_table-1
	RC
	SL
	SL			; A <- 4*A
	LIB 0
	LP REG_X
	ADB			; X <- sw_table-1 + 4*A
	RTN

; ------------------------------------------------------------------------------
; new
; delete all program slots
; ------------------------------------------------------------------------------

;sw_new:
;	LIAB sw_end
;	LIDP BASIC_END_L
;	LP REG_A
;	EXBD			; (BASIC_END) <- sw_end
;	JRM sw_set_basic

sw_new:
	LIDP sw_table_ptr
	LP REG_X
	MVBD			; X <- sw_table-1
	;LP REG_Y		; assert P == REG_Y
	LIQ REG_X
	MVB			; Y <- sw_table-1
	LIAB 4*10+10
	LP REG_X
	ADB			; X <- sw_table-1 + 4*10 + 10
	IX
	ORID 0xff		; (++X) <- 0xff = program #0 end
	LP REG_T
	LIQ REG_X
	MVB			; UT <- X
	LIDP BASIC_END_L
	LP REG_T
	EXBD			; (BASIC_END) <- UT = program #0 end
	LIA 10-1
	PUSH			; repeat 10 times
1$:	DX
	ORID 0xff		;   (--X) <- 0xff = program #i start and program #i+1 end for i=0..9
	LP REG_A
	LIQ REG_X
	MVB			;   BA <- X = program sw_table entry #i for i=0..9
	IYS			;   (++Y) <- A = XL
	EXAB
	IYS			;   (++Y) <- B = XH
	LIA 1
	IYS			;   (++Y) <- 1
	RA
	IYS			;   (++Y) <- 0
	LOOP 1$			; loop
	LIDP sw_active
	;RA			; assert A == 0
	STD			; (sw_active) <- 0
	CALL sw_set_basic	; set (BASIC_START) and (BASIC_MERGE) to program #0
	; FALL THROUGH		; display program slots

; ------------------------------------------------------------------------------
; display program slots
; 0-9: program slot unused
; _:   program slot used
; *:   program slot is the current program
; ------------------------------------------------------------------------------

sw_display:
	CAL INT_ROM_CLRSCR	; clear screen buffer
	CAL INT_ROM_DISP_LINE_0	; Y <- screen buffer line #0 - 1
	; LIAB MEM_DISP_LINE_0	; BA <- screen buffer line #0
	; CAL INT_ROM_MVYBAM	; Y <- BA-1
	RA
	CALL sw_table_cell	; X <- sw_table-1, B <- 0
	LP REG_B

sw_disp_loop:			; repeat
	IX
	IX			;   X <- X + 2
	LIDP sw_active
	LDD
	CPMA
	JRNZP 1$		;   if B == (sw_active) then
	LIA '*			;     A <- '*'
	IX
	IX			;     X <- X + 2
	JRP 3$			;   else
1$:	IXL
	IX			;     X <- X + 2
	CPIA 1
	JRNZP 2$
	TSID 0xff
	JRNZP 2$ 		;     if (X) == 0x0001 then
	LDM
	ADIA '0			;       A <- B + '0'
	JRP 3$			;     else
2$:	LIA '_			;       A <- '_'
3$:	IYS			;   (++Y) <- A
	INCB
	CPIM 10
	JRCM sw_disp_loop	; until ++B >= 10
	LIDP MEM_CMD_CSR_ROW
	RA
	STD			; (MEM_CMD_CSR_ROW) <- 0
	JP INT_ROM_DISP		; display screen buffer and return

; ------------------------------------------------------------------------------
; swap two consecutive memory blocks in place with zero storage overhead
; first block address in X, second block address in Y, combined size in BA
; changes I,A,B,X,Y,K,L,M,N,T,U,V,W
; ------------------------------------------------------------------------------

blk_swap:
	LP REG_M
	LIQ REG_A
	LII 6-1
	MVW			; save 6 registers NM <- BA, UT <- X, WV <- Y

;	1. reverse the combined memory blocks (X..X+BA-1) of size BA,
;	   this swaps the two blocks, but the data they contain is reversed

	CALL blk_reverse

;	2. reverse block (X..Y-1) of size Y-X (second block)
;	   compute:
;	     X <- UT		= start of the first block
;	     BA <- NM - WV + UT	= size of the second block
;	     UT <- UT + BA	= start of the second block (after the first reversal)
;	     NM <- NM - BA	= size of the first block

	LP REG_A
	LIQ REG_V
	MVB			; BA <- WV
	;LP REG_X		; assert P == REG_X
	LIQ REG_M
	MVB			; X <- NM
	LP REG_X
	SBB			; X <- X - BA = NM - WV
	LP REG_A
	;LIQ REG_T		; assert Q == REG_T
	MVB			; BA <- UT = start of the first block
	;LP REG_X		; assert P == REG_X
	ADB			; X <- X + BA = NM - WV + UT
	LP REG_A
	LIQ REG_X
	EXB			; X <-> BA
	LP REG_M
	SBB			; NM <- NM - BA = WV - UT = size of the first block
	LP REG_T
	ADB			; UT <- UT + BA = UT + NM - WV + UT = start of the second block
	CALL blk_reverse

;	3. reverse block (Y..X+BA-(Y-X)-1) of size BA-(Y-X) (first block)

	LP REG_A
	LIQ REG_M
	MVB			; BA <- NM = size of the first block
	MVB			; X <- UT = start of the second block
	; FALL THROUGH 

; ------------------------------------------------------------------------------
; reverse memory in place
; start address in X, size in BA
; chages A,B,X,Y,K,L
; ------------------------------------------------------------------------------

blk_reverse:
	LP REG_Y
	LIQ REG_X
	MVB			; Y <- X = start
	LP REG_Y
	ADB			; Y <- end = start + size
	;RC			; assert C=0
	EXAB
	SR
	EXAB
	SR			; BA <- size/2
	DECA
	JRNCP 1$
	DECB			; BA = size/2 - 1
	JRCP blk_reverse_exit	; if BA < 0 then return
1$:	LP REG_K
	EXAM			; BK <- size/2 - 1
	LP REG_L
	DX			; X <- start - 1

blk_reverse_loop:		; repeat
	DY
	MVMD			;   L <- (--Y)
	IXL			;   A <- (++X)
	MVDM			;   (X) <- L
	IY
	DYS			;   (Y) <- A
	DECK
	JRNCM blk_reverse_loop	; loop until --K == 0xff
	DECB
	JRNCM blk_reverse_loop	; loop until --B == 0xff

blk_reverse_exit:
	RTN

; ------------------------------------------------------------------------------
; data section
; active program (sw_active) byte value 0 to 9
; table pointer (sw_table_ptr)+1 points to sw_table
; sw_table[10] of pairs of program start address and program size words
; start address points to 0xff, start address + size points to 0xff
; active program is the last so that it can be edited in BASIC
; ------------------------------------------------------------------------------

sw_active:
	.db 0

sw_table_ptr:
	word sw_table-1

sw_table:

;	word2 sw_program0, 1
;	word2 sw_program1, 1
;	word2 sw_program2, 1
;	word2 sw_program3, 1
;	word2 sw_program4, 1
;	word2 sw_program5, 1
;	word2 sw_program6, 1
;	word2 sw_program7, 1
;	word2 sw_program8, 1
;	word2 sw_program9, 1
;
;sw_program9:
;	.db 0xff
;sw_program8:
;	.db 0xff
;sw_program7:
;	.db 0xff
;sw_program6:
;	.db 0xff
;sw_program5:
;	.db 0xff
;sw_program4:
;	.db 0xff
;sw_program3:
;	.db 0xff
;sw_program2:
;	.db 0xff
;sw_program1:
;	.db 0xff
;sw_program0:
;	.db 0xff
;sw_end:
;	.db 0xff
