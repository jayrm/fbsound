#!/bin/sh
echo "build cpu layer"
fbc  -w pendantic -mt -asm intel -i inc -lib src/fbscpu.bas -x lib/lin32/libfbscpu.a
echo "build dsp"
fbc  -w pendantic -mt -asm intel -i inc -lib src/fbsdsp.bas -x lib/lin32/libfbsdsp.a
echo "build fbsound"
fbc  -w pendantic -mt -asm intel -i inc -lib src/fbsound.bas -x lib/lin32/libfbsound.a
echo "build plug alsa"
fbc  -w pendantic -mt -asm intel -i inc -dylib src/plug-alsa.bas -x lib/lin32/libplug-alsa-32.so
echo "build plug dsp"
fbc  -w pendantic -mt -asm intel -i inc -dylib src/plug-dsp.bas -x lib/lin32/libplug-dsp-32.so
echo "build plug arts"
fbc  -w pendantic -mt -asm intel -i inc -dylib src/plug-arts.bas -x lib/lin32/libplug-arts-32.so
echo "ready!"
echo ""
echo "have fun with FreeBASIC and FBSound"
echo ""

