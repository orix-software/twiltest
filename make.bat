@ECHO OFF

SET ORICUTRON="..\..\..\oricutron\"
SET PATH=%PATH%;%CC65%

SET ORIGIN_PATH=%CD%

%OSDK%\bin\bin2txt.exe -s1 -f2 teletest21.rom teletest21.s teletest21

%OSDK%\bin\xa teletest21.asm -o teletest21_16.rom




IF "%1"=="NORUN" GOTO End

:End



