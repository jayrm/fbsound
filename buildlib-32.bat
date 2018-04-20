@echo "build FBSound 0.21 for Windows x86:"
@REM Set the right path to your 32-bit FreeBASIC compiler !
d:\FreeBASIC\fbc32.exe -w pendantic -mt -asm intel -lib src/fbscpu.bas  -x lib/win32/libfbscpu.a
d:\FreeBASIC\fbc32.exe -w pendantic -mt -asm intel -lib src/fbsdsp.bas  -x lib/win32/libfbsdsp.a
d:\FreeBASIC\fbc32.exe -w pendantic -mt -asm intel -lib src/fbsound.bas -x lib/win32/libfbsound.a
d:\FreeBASIC\fbc32.exe -w pendantic -mt -asm intel -dll src/plug-ds.bas -x lib/win32/plug-ds-32.dll
d:\FreeBASIC\fbc32.exe -w pendantic -mt -asm intel -dll src/plug-mm.bas -x lib/win32/plug-mm-32.dll
@echo "ready!"
@pause

