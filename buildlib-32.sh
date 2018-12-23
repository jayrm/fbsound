#!/bin/sh
echo "build cpu layer"
fbc  -w pendantic -mt -asm intel -i inc -lib src/fbscpu.bas -x ./lib/lin32/libfbscpu.a
echo "build dsp"
fbc  -w pendantic -mt -asm intel -i inc -lib src/fbsdsp.bas -x ./lib/lin32/libfbsdsp.a
echo "build fbsound"
fbc  -w pendantic -mt -asm intel -i inc -p ./lib/lin32/ -dylib src/fbsound.bas -x ../fbsound-1.1/tests/libfbsound-32.so
echo "build plug alsa"
fbc  -w pendantic -mt -asm intel -i inc -dylib src/plug-alsa.bas -x ../fbsound-1.1/tests/libplug-alsa-32.so
echo "build plug dsp"
fbc  -w pendantic -mt -asm intel -i inc -dylib src/plug-dsp.bas  -x ../fbsound-1.1/tests/libplug-dsp-32.so
echo "build plug arts"
fbc  -w pendantic -mt -asm intel -i inc -dylib src/plug-arts.bas -x ../fbsound-1.1/tests/libplug-arts-32.so
echo "ready!"
echo ""
echo "have fun with FreeBASIC and FBSound"
echo ""

