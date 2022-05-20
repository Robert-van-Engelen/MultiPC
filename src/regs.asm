; CPU registers

REG_I  = 0x00			; index register
REG_J  = 0x01			; index register (always 1)
REG_A  = 0x02			; accumulator
REG_B  = 0x03			; accumulator
REG_X  = 0x04			; X address register
REG_XL = 0x04			; LSB of X address register
REG_XH = 0x05			; MSB of X address register
REG_Y  = 0x06			; Y address register
REG_YL = 0x06			; LSB of Y address register
REG_YH = 0x07			; MSB of Y address register
REG_K  = 0x08			; counter
REG_L  = 0x09			; counter
REG_M  = 0x0A			; counter
REG_N  = 0x0B			; counter
REG_T  = 0x0C			; temporary register in working area
REG_U  = 0x0D			; temporary register in working area
REG_V  = 0x0E			; temporary register in working area
REG_W  = 0x0F			; temporary register in working area

; BCD pseudo registers

X_REG = 0x10			; Xreg 0x10-0x17
Y_REG = 0x18			; Yreg 0x18-0x1F
Z_REG = 0x20			; Zreg 0x20-0x27
W_REG = 0x28			; Wreg 0x28-0x2F

; BASIC

ERN = 0x34			; error number
STATE = 0x35			; BASIC state 1=BREAK, 2, 4, 8, 16, 32, 64=(CUR_EXEC) is valid

CUR_EXEC_L  = 0x38		; current program executed line address low order byte
CUR_EXEC_H  = 0x39		; current program executed line address high order byte
CUR_START_L = 0x3E		; current program executed start low order byte
CUR_START_H = 0x3F		; current program executed start high order byte

SEARCH_ADDR_L = 0x3A		; search address low order byte
SEARCH_ADDR_H = 0x3B		; search address high order byte
SEARCH_LINE_L = 0x3C		; search line number low order byte
SEARCH_LINE_H = 0x3D		; search line number high order byte

; Ports

PORT_A = 92			; port A
PORT_B = 93			; port B
PORT_F = 94			; port F
PORT_C = 95			; control port C

; Port C mask

PORT_C_DISPLAY   = 0x01		; display on=1/off=0
PORT_C_CNT_RESET = 0x02		; counter reset=1
PORT_C_CPU_HALT  = 0x04		; CPU halt=1 until 512 ms counter rises
PORT_C_PWR_DOWN  = 0x08		; power down=1
PORT_C_BEEP_FREQ = 0x10		; beeper frequency 2kHz/4kHz=1 if bit 5 set
				; Xout on=1/off if bit 5 not set
PORT_C_BEEP_CTRL = 0x20		; 2KHz/4Khz beep
PORT_C_XIN_ENBL  = 0x40		; Xin readable with TEST if set

; TEST mask

TEST_CNT_512 = 0x01		; 512 ms counter
TEST_CNT_2   = 0x02		; 2 ms counter
TEST_BRK     = 0x08		; break key
TEST_RESET   = 0x40		; hard reset
TEST_XIN     = 0x80		; Xin port

; Macros to store little-endian words for MVBD, EXBD etc

.macro	word addr
	.db <(addr), >(addr)
.endm

.macro	word2 addr1, addr2
	word addr1
	word addr2
.endm

; Macro to define often-used LIAB

.macro	LIAB word
	LIA <(word)
	LIB >(word)
.endm
