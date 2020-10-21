@echo "build FBSound 1.2 for Windows x86_64:"
@REM Set the right path to your 64-bit FreeBASIC compiler !
d:\FreeBASIC\fbc64.exe -w pedantic -mt -gen gcc -asm intel -lib src/fbscpu.bas -x ./lib/win64/libfbscpu.a
d:\FreeBASIC\fbc64.exe -w pedantic -mt -gen gcc -asm intel -lib src/fbsdsp.bas -x ./lib/win64/libfbsdsp.a
d:\FreeBASIC\fbc64.exe -w pedantic -mt -gen gcc -asm intel -p ./lib/win64 -dll src/fbsound.bas -x ../fbsound-1.2/tests/fbsound-64.dll
d:\FreeBASIC\fbc64.exe -w pedantic -mt -gen gcc -asm intel -dll src/plug-ds.bas -x ../fbsound-1.2/tests/fbsound-ds-64.dll
d:\FreeBASIC\fbc64.exe -w pedantic -mt -gen gcc -asm intel -dll src/plug-mm.bas -x ../fbsound-1.2/tests/fbsound-mm-64.dll
del ..\fbsound-1.2\tests\libfbsound-64.dll.a
del ..\fbsound-1.2\tests\libfbsound-ds-64.dll.a
del ..\fbsound-1.2\tests\libfbsound-mm-64.dll.a
@echo "ready!"
@pause

