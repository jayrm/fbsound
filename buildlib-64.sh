#!/bin/sh
echo "build cpu layer"
fbc  -w pendantic -mt -asm intel -i inc -lib src/fbscpu.bas -x lib/lin64/libfbscpu.a
echo "build dsp"
fbc  -w pendantic -mt -asm intel -i inc -lib src/fbsdsp.bas -x lib/lin64/libfbsdsp.a
echo "build fbsound"
fbc  -w pendantic -mt -asm intel -i inc -lib src/fbsound.bas -x lib/lin64/libfbsound.a
echo "build plug alsa"
fbc  -w pendantic -mt -asm intel -i inc -dylib src/plug-alsa.bas -x lib/lin64/libplug-alsa-64.so

echo "ready!"
echo ""
echo "have fun with FreeBASIC and FBSound"
echo ""

