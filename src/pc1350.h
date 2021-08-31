; -----------------------------------------------
; PShell - a runtime environment for    
; sharp pocket computers                 
; file     : pc1350.h                   
; author   : puehringer edgar           
; date     : 29.02.2004                 
; version  : 1.0.0                      
; assembler: as61860                    
;                                       
; Contains machine dependant constanst
; -----------------------------------------------

; Flags for conditional assembly - this
; models will be supported (maybe)

__PC_1262__  = 0
__PC_1280__  = 0
__PC_1350__  = 1
__PC_1360__  = 0
__PC_1402__  = 0
__PC_1403__  = 0

; Bankswitch flag
; 1 if this is a model with bankswitched
; ROM, 0 otherwise

__PC_IS_BANKSWITCHED__  = 0

; Keyboard matrix flag
; 1 if this is a model which addresses
; a part of the keyboard with the gate
; array, 0 otherwise (addressed by port B)

__PC_KBD_GATE_ARRAY__ = 1

; Small characters availablility flag
; 1 if available, 0 otherwise

__PC_HAS_LOWERCASE_CHARS__ = 1

; Mode button availablility flag (otherwise includes into power switch)
; 1 if available, 0 otherwise

__PC_HAS_MODE_BTN__ = 1

; Resonator frequency
; On of these defines must be 1 to indicate the resonator frequency of
; the calculator
  
__PC_RESONATOR_576K__ = 0
__PC_RESONATOR_768K__ = 1
__PC_RESONATOR_800K__ = 0

; Keycodes
; Note: the BRK key is not included into
; this constants, because it is read with
; the TEST instruction

KEY_A	       =   29
KEY_B	       =   58
KEY_C	       =   44
KEY_D	       =   43
KEY_E	       =   42
KEY_F	       =   50
KEY_G	       =   57
KEY_H	       =    1
KEY_I	       =   11
KEY_J	       =    7
KEY_K	       =   12
KEY_L	       =   16
KEY_M	       =    8
KEY_N	       =    2
KEY_O	       =   15
KEY_P	       =   18
KEY_Q	       =   28
KEY_R	       =   49
KEY_S	       =   36
KEY_T	       =   56
KEY_U	       =    6
KEY_V	       =   51
KEY_W	       =   35
KEY_X	       =   37
KEY_Y	       =    0
KEY_Z	       =   30

KEY_1	       =   53
KEY_2	       =   46
KEY_3          =   39
KEY_4          =   54
KEY_5          =   47
KEY_6          =   40
KEY_7          =   55
KEY_8	       =   48
KEY_9	       =   41
KEY_0          =   52

KEY_SPACE      =   13
KEY_RETURN     =   17  ; the ENTER key
KEY_ESC        =   14  ; the C-CE or CLS key (F1 on lolos emu)

KEY_CAPS_LOCK  =   23  ; the SML key
KEY_CTRL       =   22  ; the DEF key (TAB on lolos emu)
KEY_SHIFT_L    =   KEY_UNDEF
KEY_SHIFT_R    =   21  ; (left SHIFT on lolos emu)

KEY_DOWN       =   61
KEY_UP         =   62
KEY_LEFT       =   60
KEY_RIGHT      =   59
KEY_DEL        = KEY_UNDEF
KEY_INS        = KEY_UNDEF

KEY_COLON      = KEY_UNDEF
KEY_SEMICOLON  = KEY_UNDEF
KEY_COMMA      =   24  ; the , key
KEY_PERIOD     =   45  ; the . key

KEY_PLUS       =   38
KEY_MINUS      =   31
KEY_ASTERISK   =   32  ; the * key (lolos emu: on numeric block)
KEY_SLASH      =   33  ; the 'divide' key on PC-1403(H) (lolos emu: on numeric block)
KEY_PARENLEFT  =   34  ; the ( key (F2 on lolos emu)
KEY_PARENRIGHT =   27  ; the ) key (F3 on lolos emu)
KEY_EQUAL      =   19  ; (# on lolos emu)

; Special keys

KEY_MODE       =   9   ; (F10 on lolos emu)

; Keys not available on PC-1350

KEY_UNDEF       = 0xfe

KEY_CAL         =   KEY_UNDEF

KEY_PLUS_MIN    =   KEY_UNDEF  ; the +/- key

KEY_HYP         =   KEY_UNDEF
KEY_SIN         =   KEY_UNDEF
KEY_COS         =   KEY_UNDEF
KEY_TAN         =   KEY_UNDEF
KEY_FSE         =   KEY_UNDEF
KEY_HEX         =   KEY_UNDEF
KEY_DEG         =   KEY_UNDEF
KEY_LN          =   KEY_UNDEF
KEY_LOG         =   KEY_UNDEF
KEY_RCP         =   KEY_UNDEF  ; the 1/X key
KEY_UP_DOWN     =   KEY_UNDEF  ; the up/down arrow key
KEY_EXP         =   KEY_UNDEF
KEY_ASCIICIRCUM =   KEY_UNDEF  ; the ^ or y^X key
KEY_SQR         =   KEY_UNDEF  ; the square root key
KEY_SQU         =   KEY_UNDEF  ; the x^2 key

KEY_M_PLUS      =   KEY_UNDEF  ; the M+ key
KEY_M_SET       =   KEY_UNDEF  ; the X>M key
KEY_M_RECALL    =   KEY_UNDEF  ; the RM key

KEY_M_MINUS     = KEY_UNDEF  ; the M- key
KEY_M_CLEAR     = KEY_UNDEF  ; the CM key      

KEY_OFF         = KEY_UNDEF

KEY_PERCENT_R   = KEY_UNDEF

KEY_EXCLAM      = KEY_UNDEF
KEY_QUOTEDBL    = KEY_UNDEF  ; the \" key
KEY_NUMBERSIGN  = KEY_UNDEF  ; the # key
KEY_DOLLAR      = KEY_UNDEF
KEY_PERCENT_L   = KEY_UNDEF

; The offset between port A and port K matrix

KEYPORT_OFFS = 21

MEM_DISP_LINE_0 = 0x6d00
MEM_DISP_LINE_1 = 0x6d18
MEM_DISP_LINE_2 = 0x6d30
MEM_DISP_LINE_3 = 0x6d48
MEM_DISP_CSR_ROW = 0x7880               ; cursor row position
MEM_DISP_CSR_COL = 0x7881               ; cursor col position
MEM_DISP_CSR_X   = 0x788b               ; cursor x position
MEM_DISP_CSR_Y   = 0x788c               ; cursor y position
MEM_CMD_CSR_ROW  = 0x7897               ; command (in RUN MODE) cursor row position
MEM_CMD_CSR_COL  = 0x7898               ; command (in RUN MODE) cursor col position

; BASIC system pointers

BASIC_START_L = 0x6f01                  ; pointer to basic start low byte
BASIC_START_H = 0x6f02                  ; pointer to basic start high byte
BASIC_END_L   = 0x6f03                  ; pointer to basic end low byte
BASIC_END_H   = 0x6f04                  ; pointer to basic end high byte
BASIC_MERGE_L = 0x6f05                  ; pointer to basic merge low byte
BASIC_MERGE_H = 0x6f06                  ; pointer to basic merge high byte

; Memory location

BASVAR_STR_ESC = 0xF5;   245            ; Excape character to indicate a
                                        ; string variable
MEM_BASVAR_Z  = 0x6C30;  27696          ; Basic std var Z
MEM_BASVAR_Y  = MEM_BASVAR_Z + 8;
MEM_BASVAR_X  = MEM_BASVAR_Y + 8;
MEM_BASVAR_W  = MEM_BASVAR_X + 8;
MEM_BASVAR_V  = MEM_BASVAR_W + 8;
MEM_BASVAR_U  = MEM_BASVAR_V + 8;
MEM_BASVAR_T  = MEM_BASVAR_U + 8;
MEM_BASVAR_S  = MEM_BASVAR_T + 8;
MEM_BASVAR_R  = MEM_BASVAR_S + 8;
MEM_BASVAR_Q  = MEM_BASVAR_R + 8;
MEM_BASVAR_P  = MEM_BASVAR_Q + 8;
MEM_BASVAR_O  = MEM_BASVAR_P + 8;
MEM_BASVAR_N  = MEM_BASVAR_O + 8;
MEM_BASVAR_M  = MEM_BASVAR_N + 8;
MEM_BASVAR_L  = MEM_BASVAR_M + 8;
MEM_BASVAR_K  = MEM_BASVAR_L + 8;
MEM_BASVAR_J  = MEM_BASVAR_K + 8;
MEM_BASVAR_I  = MEM_BASVAR_J + 8;
MEM_BASVAR_H  = MEM_BASVAR_I + 8;
MEM_BASVAR_G  = MEM_BASVAR_H + 8;
MEM_BASVAR_F  = MEM_BASVAR_G + 8;
MEM_BASVAR_E  = MEM_BASVAR_F + 8;
MEM_BASVAR_D  = MEM_BASVAR_E + 8;
MEM_BASVAR_C  = MEM_BASVAR_D + 8;
MEM_BASVAR_B  = MEM_BASVAR_C + 8;
MEM_BASVAR_A  = MEM_BASVAR_B + 8;

MEM_INPUT_BUF = 0x6EB0;  28336          ; The input buffer 80 byte
MEM_BAS_WAIT  = 0x70B3;  28851          ; Duration of WAIT interval

MEM_LCD_L1C1  = 0x7000;	 28672		; Screen organization RAM
MEM_LCD_L1C2  = 0x7200;	 29184		; LnCm = Line n Column m
MEM_LCD_L1C3  = 0x7400;	 29696
MEM_LCD_L1C4  = 0x7600;	 30208
MEM_LCD_L1C5  = 0x7800;	 30720
MEM_LCD_L2C1  = 0x7040;	 28736
MEM_LCD_L2C2  = 0x7240;	 29248
MEM_LCD_L2C3  = 0x7440;	 29760
MEM_LCD_L2C4  = 0x7640;	 30272
MEM_LCD_L2C5  = 0x7840;	 30784
MEM_LCD_L3C1  = 0x701E;	 28702
MEM_LCD_L3C2  = 0x721E;	 29214
MEM_LCD_L3C3  = 0x741E;	 29726
MEM_LCD_L3C4  = 0x761E;  30238
MEM_LCD_L3C5  = 0x781E;	 30750
MEM_LCD_L4C1  = 0x705E;	 28766
MEM_LCD_L4C2  = 0x725E;	 29278
MEM_LCD_L4C3  = 0x745E;	 29790
MEM_LCD_L4C4  = 0x765E;	 30302
MEM_LCD_L4C5  = 0x785E;	 30814

;MEM_LCD_FLAGS = 0x783C;  30780
; Flags for status sysmols on LCD

MEM_LCDA_RUN  = 0x783C;  30780
MEM_LCDA_PRO  = MEM_LCDA_RUN

MEM_LCDF_RUN  = 0x10;
MEM_LCDF_PRO  = 0x20;

MEM_LCDM_RUN  = 0xEF;
MEM_LCDM_PRO  = 0xDF;

MEM_LCD_BASE  = 0x7000;  Display memory base address
MEM_LCD_COFFS = 0x0200;  Offset between column blocks

MEM_LCD_L1    = 0x00;    Line 1 lowbyte
MEM_LCD_L2    = 0x40;    Line 2 lowbyte
MEM_LCD_L3    = 0x1E;    Line 3 lowbyte
MEM_LCD_L4    = 0x5E;    Line 4 lowbyte

MEM_KEYPORT	= 0x3E00    ; address of key port

MEM_CHARTAB     = 0x7FF0

__INVERS_CHARTAB__  = 1

.if  __RAM_SLOT1__ - 16

.if  __RAM_SLOT1__ - 8

.if  __RAM_SLOT1__

; Wrong memory configuration
.error 2

.else

; We have no RAM card
RAM_START = 0x6000

.endif

.else

; We have a 8k RAM card
RAM_START = 0x4000

.endif

.else

; We have a 16k RAM card
RAM_START = 0x2000

.endif

RAM_BASIC_START_L = RAM_START + 0x07
RAM_BASIC_START_H = RAM_START + 0x08
RAM_BASIC_END_L   = RAM_START + 0x09
RAM_BASIC_END_H   = RAM_START + 0x0A
RAM_BASIC_MERGE_L = RAM_START + 0x0B
RAM_BASIC_MERGE_H = RAM_START + 0x0C
RAM_BASIC         = RAM_START + 0x30

; LCD properties

LCD_ROWS       =  4
LCD_COLS       = 24
LCD_COL_WIDTH  =  6  ; 5 on systems without full graphic screen like PC-1403
LCD_CHAR_WIDTH =  5

; CPU internal ROM calls

INT_ROM_LCD_OFF     = 0x04AD  ; Display OFF
INT_ROM_LCD_ON      = 0x04B1  ; Display ON
INT_ROM_WAIT6MS     = 0x09E8  ; Wait for 6 milliseconds
INT_ROM_CLRSCR      = 0x1E0C  ; Clear screen buffer
INT_ROM_DISP        = 0x1DCF  ; Display screen buffer 
;INT_ROM_KPRESS	    = 0x1E9C  ; Keypressed function, also for PC-1360, hmm... this crashes in lolos emu
INT_ROM_RAWKEY	    = 0x0436  ; Keypressed function for raw keys, non blocking (1078)
INT_ROM_KPRESS	    = 0x0BBB  ; Keypressed function, non blocking (3003)
INT_ROM_GETKEY      = 0x120A  ; Getkey function, blocking, with SHIFT evaluation (4618)
INT_ROM_PWRDOWN     = 0x04D8  ; Power Down
INT_ROM_BEEP        = 0x094B  ; Short beep, hmm works only correct when called from basic
INT_ROM_DISP_LINE_0 = 0x02AA  ; Move Y <- screen buffer line #0 - 1

INT_ROM_MVSAVEX     = 0x0A0A  ; Move SAVE <- X
INT_ROM_MVXSAVE     = 0x0A17  ; Move X <- SAVE

INT_ROM_SAVEX       = 0x1D84  ; Move CALL Rtn @dr <- X
INT_ROM_LOADX       = 0x1D89  ; Move X <- CALL Rtn @dr
INT_ROM_MVXBA       = 0x0282  ; Move X <- BA
INT_ROM_MVXBAP      = 0x0287  ; Move X <- BA+1
INT_ROM_MVXBAM      = 0x0297  ; Move X <- BA-1
INT_ROM_MVYBA       = 0x027D  ; Move Y <- BA
INT_ROM_MVYBAP      = 0x028D  ; Move Y <- BA+1
INT_ROM_MVYBAM      = 0x02B5  ; Move Y <- BA-1
INT_ROM_EXYBA       = 0x17B5  ; Exchange Y <-> BA
INT_ROM_PUSHX       = 0x115C  ; Push X
INT_ROM_POPX        = 0x1167  ; Pop X
INT_ROM_MVXY        = 0x1419  ; Move X <- Y
INT_ROM_MVYX        = 0x1414  ; Move Y <- X

INT_ROM_ERROR_1     = 0x10EC  ; ERROR 1
INT_ROM_ERROR_2     = 0x10E4  ; ERROR 2
INT_ROM_ERROR_3     = 0x10F0  ; ERROR 3
INT_ROM_ERROR_4     = 0x10F4  ; ERROR 4
INT_ROM_ERROR_5     = 0x10F8  ; ERROR 5
INT_ROM_ERROR_6     = 0x10FC  ; ERROR 6
INT_ROM_ERROR_7     = 0x1100  ; ERROR 7
INT_ROM_ERROR_8     = 0x1104  ; ERROR 8
INT_ROM_ERROR_9     = 0x1108  ; ERROR 9
INT_ROM_ERROR       = 0x10E6  ; ERROR

; external ROM calls (I only know ROM1 addresses, please help ...)

.if  __ROM_VERS__

EXT_ROM_TESTPRN = 0x8045  ; Test printer on
EXT_ROM_PRINTA  = 0xA372  ; Print content of register A
EXT_ROM_SCROLL  = 0xE23C  ; Scroll the display

.endif
