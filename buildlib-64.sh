#!/bin/sh
echo "build cpu layer"
fbc  -w pendantic -mt -asm intel -i inc -lib -pic src/fbscpu.bas -x ./lib/lin64/libfbscpu.a
echo "build dsp"
fbc  -w pendantic -mt -asm intel -i inc -lib -pic src/fbsdsp.bas -x ./lib/lin64/libfbsdsp.a
echo "build fbsound"
fbc  -w pendantic -mt -asm intel -i inc -p ./lib/lin64/ -dylib src/fbsound.bas -x ../fbsound-1.1/tests/libfbsound-64.so
echo "build plug alsa"
fbc  -w pendantic -mt -asm intel -i inc -dylib src/plug-alsa.bas -x ../fbsound-1.1/tests/libplug-alsa-64.so

echo "ready!"
echo ""
echo "have fun with FreeBASIC and FBSound"
echo ""

