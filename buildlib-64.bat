@echo "build FBSound 0.21 for Windows x86_64:"
@REM Set the right path to your 64-bit FreeBASIC compiler !
d:\FreeBASIC\fbc64.exe -w pendantic -mt -asm intel -lib src/fbscpu.bas -x lib/win64/libfbscpu.a
d:\FreeBASIC\fbc64.exe -w pendantic -mt -asm intel -lib src/fbsdsp.bas -x lib/win64/libfbsdsp.a
d:\FreeBASIC\fbc64.exe -w pendantic -mt -asm intel -lib src/fbsound.bas -x lib/win64/libfbsound.a
d:\FreeBASIC\fbc64.exe -w pendantic -mt -asm intel -dll src/plug-ds.bas -x lib/win64/plug-ds-64.dll
d:\FreeBASIC\fbc64.exe -w pendantic -mt -asm intel -dll src/plug-mm.bas -x lib/win64/plug-mm-64.dll
@echo "ready!"
@pause

