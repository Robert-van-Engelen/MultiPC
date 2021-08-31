# tools

ASM=../../as61860
ASMFLAGS=-los

LNK=../../aslink
LNKFLAGS=-imwu -b PROGRAM=RAM_BASIC

IHX2BAS=../../ihx/ihx2bas

RM=rm -f

# files

LDR=multipc.bas
HEX=multipc.ihx
OBJ=multipc.rel
TRG=pc1350.h

# rules

all:	$(LDR)

$(LDR): $(HEX)
	$(IHX2BAS) $(HEX) $(LDR)
	@echo "9000 CALL A,NEW:END" >> $(LDR)
	@echo "9001 \"A\" V=0:GOTO \"P\"" >> $(LDR)

$(HEX): $(OBJ)
	$(LNK) $(LNKFLAGS) $(HEX) $(OBJ)

%.rel: %.asm $(TRG) target.h regs.h
	$(ASM) $(ASMFLAGS) $<

clean:
	$(RM) *.rel *.sym *.hlr *.map *.lst *.rst

distlean:
	$(RM) *.rel *.sym *.hlr *.map *.lst *.rst $(HEX) $(LDR)

.PHONY: all clean distclean
