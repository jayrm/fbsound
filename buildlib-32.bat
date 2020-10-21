@echo "build FBSound 1.2 for Windows x86:"
@REM Set the right path to your 32-bit FreeBASIC compiler !
d:\FreeBASIC\fbc32.exe -w pedantic  -mt -gen gcc -asm intel -lib src/fbscpu.bas -x ./lib/win32/libfbscpu.a
d:\FreeBASIC\fbc32.exe -w pedantic  -mt -gen gcc -asm intel -lib src/fbsdsp.bas -x ./lib/win32/libfbsdsp.a
d:\FreeBASIC\fbc32.exe -w pedantic  -mt -gen gcc -asm intel -p ./lib/win32 -dll src/fbsound.bas -x ../fbsound-1.2/tests/fbsound-32.dll
d:\FreeBASIC\fbc32.exe -w pedantic  -mt -gen gcc -asm intel -dll src/plug-ds.bas -x ../fbsound-1.2/tests/fbsound-ds-32.dll
d:\FreeBASIC\fbc32.exe -w pedantic  -mt -gen gcc -asm intel -dll src/plug-mm.bas -x ../fbsound-1.2/tests/fbsound-mm-32.dll
del ..\fbsound-1.2\tests\libfbsound-32.dll.a
del ..\fbsound-1.2\tests\libfbsound-ds-32.dll.a
del ..\fbsound-1.2\tests\libfbsound-mm-32.dll.a
@echo "ready!"
@pause

