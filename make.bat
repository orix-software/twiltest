@ECHO OFF

SET ORICUTRON="..\..\..\oricutron\"
SET PATH=%PATH%;%CC65%

SET ORIGIN_PATH=%CD%

%OSDK%\bin\bin2txt.exe -s1 -f2 teletest21.rom teletest21.s teletest21

%OSDK%\bin\xa teletest21.asm -o teletest21_16.rom

%OSDK%\bin\xa teletest30.asm -o teletest30.rom


copy teletest30.rom /b + teletest30.rom /b + orix10_6502.rom + teletest30.rom /b cardridge_test.rom


IF "%1"=="NORUN" GOTO End

copy teletest30.rom %ORICUTRON%\roms\teletest30.rom
cd %ORICUTRON%
OricutronV4 -mt -d teledisks\stratsed.dsk
cd %ORIGIN_PATH%
:End



