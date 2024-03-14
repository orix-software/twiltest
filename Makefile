AS=ca65
CC=cl65
LD=ld65
CFLAGS=-ttelestrat
LDFILES=
ROM=twilighte_board_test


.PHONY : all

SOURCE=src/$(ROM).asm

ifeq ($(CC65_HOME),)
        CC = cl65
        AS = ca65
        LD = ld65
        AR = ar65
else
        CC = $(CC65_HOME)/bin/cl65
        AS = $(CC65_HOME)/bin/ca65
        LD = $(CC65_HOME)/bin/ld65
        AR = $(CC65_HOME)/bin/ar65
endif

all:
	for number in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30; do \
		$(AS) $(CFLAGS) $(SOURCE) -o $(ROM).ld65 --debug-info -DID_BANK=$$number ;\
		$(LD) -vm -m map7banks.txt -Ln memorymap.txt  -tnone $(ROM).ld65 -o build/all/$(ROM)_$$number.rom ;\
	done

	cat build/all/$(ROM)_1.rom > build/final.rom
	cat build/all/$(ROM)_2.rom >> build/final.rom
	cat build/all/$(ROM)_3.rom >> build/final.rom
	cat build/all/$(ROM)_4.rom >> build/final.rom
	cat build/all/$(ROM)_5.rom >> build/final.rom
	cat build/all/$(ROM)_6.rom >> build/final.rom
	cat build/all/$(ROM)_7.rom >> build/final.rom


