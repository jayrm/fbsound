#!/bin/sh
echo "build FBSound 1.2 for Linux x86:"
echo "build Linux x86 ./lib/lin32/libfbscpu.a"
fbc -g -w pedantic -w pedantic -mt -asm intel -i inc -lib src/fbscpu.bas -x ./lib/lin32/libfbscpu.a
echo "build Linux x86 ./lib/lin32/libfbsdsp.a"
fbc -g -w pedantic -w pedantic -mt -asm intel -i inc -lib src/fbsdsp.bas -x ./lib/lin32/libfbsdsp.a
echo "build Linux x86 ../fbsound-1.2/tests/libfbsound-32.so"
fbc -g -w pedantic -w pedantic -mt -asm intel -i inc -p ./lib/lin32/ -dylib src/fbsound.bas -x ../fbsound-1.2/tests/libfbsound-32.so
echo "build Linux x86 ../fbsound-1.2/tests/libfbsound-alsa-32.so"
fbc -g -w pedantic -w pedantic -mt -asm intel -i inc -dylib src/plug-alsa.bas -x ../fbsound-1.2/tests/libfbsound-alsa-32.so
echo "ready!"
echo ""
echo "have fun with FreeBASIC and FBSound"
echo ""

