#!/bin/sh
echo "build FBSound 1.2 for Linux x86_64:"
echo "build Linux x86_64 ./lib/lin64/libfbscpu.a"
fbc -g -w pedantic -mt -asm intel -i inc -lib -pic src/fbscpu.bas -x ./lib/lin64/libfbscpu.a
echo "build Linux x86_64 ./lib/lin64/libfbsdsp.a"
fbc -g -w pedantic -mt -asm intel -i inc -lib -pic src/fbsdsp.bas -x ./lib/lin64/libfbsdsp.a
echo "build Linux x86_64 ../fbsound-1.2/tests/libfbsound-64.so"
fbc -g -w pedantic -mt -asm intel -i inc -p ./lib/lin64/ -dylib src/fbsound.bas -x ../fbsound-1.2/tests/libfbsound-64.so
echo "build Linux x86_64 ../fbsound-1.2/tests/libfbsound-alsa-64.so"
fbc -g -w pedantic -mt -asm intel -i inc -dylib src/plug-alsa.bas -x ../fbsound-1.2/tests/libfbsound-alsa-64.so
echo "ready!"
echo ""
echo "have fun with FreeBASIC and FBSound"
echo ""

