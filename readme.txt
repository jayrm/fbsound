fbsound-1.2
===========

A free sound library primarily for games and demos written by D.J. Peters.
It supports dynamically loadable plugin's. The API interface is written
for the open source FreeBASIC compiler.

Copyright 2005-2020 by D.J.Peters (Joshy) <d.j.peters[at]web.de>

Options for static library added by Jeff Marshall <coder[at]execulink.com>


License
-------

Source code by D.J. Peters is released in to the public domain.
Source code by Jeff Marshall is released in to the public domain.

If you require a specific license to attach to your project, sources provided
by the above listed authors are also dual licensed under MIT license.


fbsound-1.2 - A free sound library for FreeBASIC compiler
---------------------------------------------------------

MIT License

Copyright (c) 2023 - D.J. Peters and other contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


Supporting works
----------------

Other open sources and open sourced libraries used by this project retain their
respective licenses.

  + libogg - Reference implementation of the Ogg media container
    * Copyright Xiph.org Foundation

  + libvorbis - Reference implementation of the Ogg Vorbis audio format
    * Copyright Xiph.org Foundation

  + libmad - MPEG audio decoder library
     * Copyright Underbit Technologies, Inc.

  + libdumb - Dynamic Universal Music Bibliotheque
    * Copyright Ben Davis, Robert J Ohannessian
    *           and Julien Cugniere

  + libcsidlight - SID Emulator for playing C64 SID streams
    * various authors and contributors


TODO
====
- documentation for using static versus dynamic libraries
- develop and test changes for linux (currently only win32 tested)


Original Release Notices (on www.freebasic.net)
===============================================
In order from newest to oldest.

fbsound 1.2 Windows/Linux (sid wav mp3 ogg mod it xm s3m)
---------------------------------------------------------
https://www.freebasic.net/forum/viewtopic.php?t=28905

Post by D.J.Peters - Oct 21, 2020 0:14
fbsound 1.2 is a auto loaded dynamic lib now
(no need to copy any files to windows/system32 or lib folders on Linux)

This is for Windows the final version now !

The Linux version is compiled with console debug infos !

Download binary release: fbsound-1.2.zip last upload from: Oct 21, 2020
https://shiny3d.de/public/fbsound/fbsound-1.2.zip

Download source code: fbsound-1.2-src.zip last upload from: Oct 21, 2020
https://shiny3d.de/public/fbsound/fbsound-1.2-src.zip

The zip file is for Window and Linux 32 and 64-bit !

On Windows 32-bit you need only:
fbsound-32.dll and fbsound-mm-32.dll

On Windows 64-bit you need only:
fbsound-64.dll and fbsound-mm-64.dll

On Linux 32-bit you need only:
libfbsound-32.so and libfbsound-alsa-32.so

On Linux 64-bit you need only:
libfbsound-64.so and libfbsound-alsa-64.so

Ofcourse the include file "fbsound_dynamic.bi" on all systems :-)

Test all examples from /tests folder and report any problems please !

On Linux dylibfree() makes sometimes trouble i'm working on it
(that is an old known FreeBASIC problem)

Joshy

EDIT: How to compile fbsound 1.2 !
You have to extract both zip files: fbsound-1.2.zip and fbsound-1.2-src.zip

result on Windows:
ANY_DRIVE:\SAME_PATH\fbsound-1.2\
ANY_DRIVE:\SAME_PATH\fbsound-1.2-src\

result on Linux:
$HOME/fbsound-1.2/
$HOME/fbsound-1.2-src/

First before you execute any buildlib script from fbsound-1.2-src folder
edit the script (*.bat or *.sh) and set the right path's !

for example on my win64 box I have fbc for 32-bit and 64-bit in the same
folder but with different names !
d:\FreeBASIC\fbc32.exe
d:\FreeBASIC\fbc64.exe

On Linux before you can execute any buildlib*.sh script you must make it
executable.

cd fbsound-1.2-src
chmod +x ./bildlib-32.sh
or
chmod +x ./bildlib-64.sh

On both Windows and Linux the results of the build process from
"fbsound-1.2-src" folder are stored in: "fbsound-1.2/tests"

Why building fbsound-1.2 self ? "The question of the day :-)"

Imagine you create a demo or a complete game and you like to publish it
for Windows and Linux both 32/64-bit.

For example if your game used only *.wav files you can edit the
file: "fbsound-1.2-src/inc/fbstypes.bi" and disable all other file formats.

Code: Select all

' disable some features and rebuild the lib
#define NO_MP3
#define NO_OGG
#define NO_MOD
#define NO_SID

with this changes execute the "buildlib-xx" scrips
copy the uncommented defines or edit the same defines
in "/fbsound-1.2/inc/fbsound-dynamic.bi"

Code: Select all

' # fbsound_dynamic.bi #
#define NO_MP3       ' no MP3 sound and stream
#define NO_OOG       ' no Vorbis sound
#define NO_MOD       ' no tracker modules
#define NO_SID       ' no SID stream

Ofcourse for your final project you should comment "'#define DEBUG" in:
"/fbsound-1.2-src/inc/fbstypes.bi"
and
"/fbsound-1.2/inc/fbsound-dynamic.bi"

Same for other options: NO_DSP NO_PLUG_DS NO_PLUG_MM NO_PLUG_ARTS NO_PLUG_DSP
Remember any changes you made in file: fbsound-1.2-src/inc/fbs_types.bi must
done in file: fbsound-1.2/inc/fbsound_dynamic.bi also !°

IMPORTANT IMPORTANT IMPORTANT
The Linux version used #define DEBUG and the fbc -g compiler switch.
You can remove "-g" switch in the buildlib scripts also !

EDIT: A note about fbsound-1.2 output drivers:
On Windows 32/64-bit the DirectX sound drivers are optional fbsound-ds-32.dll
and fbsound-ds-64.dll and can be deleted !
(you can #define NO_PLUG_DS and recompile the lib if you like but deleting
only is OK also)

On Linux 32-bit the "/dev/dsp" and ARTS server driver libfbsound-dsp-32.dll
and libfbsound-arts-32.dll are optional and can be deleted !
(you can #define NO_PLUG_DSP #define NO_PLUG_ARTS and recompile the lib if
you like but deleting only is OK also)

Again OPTIONAL means OPTIONAL you can delete it without to recompile
the library !

If I self write a game (and I do it since last 3 month a real secret) I would
prever to add a sound device selection menu.
So it's the user's choice to select a play back device and and its parameters.

something like:
(*) Windows default device
( ) DirectX device
( ) 98 KHz (*) 44 KHz ( ) 22 KHz
(*) stereo ( ) mono
...
Last edited by D.J.Peters on Oct 12, 2022 18:14, edited 9 times in total.


fbsound 1.1 (dynamic) Windows/Linux 32 and 64-bit (wav mp3 ogg mod it xm s3m)
-----------------------------------------------------------------------------
https://www.freebasic.net/forum/viewtopic.php?t=27272
Post by D.J.Peters - Dec 22, 2018 20:00
fbsound 1.1 is a auto loaded dynamic lib now !

(no need to copy any files to windows/system or lib folders on Linux)

I added first oop tests also.

Download binary release: fbsound-1.1.zip last upload from: Sep 27, 2020
https://shiny3d.de/public/fbsound/fbsound-1.1.zip

Download source code: fbsound-1.1-src.zip last upload from: Dec 23, 2018
https://shiny3d.de/public/fbsound/fbsound-1.1-src.zip

Last edited by D.J.Peters on Oct 12, 2022 18:17, edited 8 times in total.


fbsound 1.0 Win/Lin 32/64-bit (wav mp3 ogg mod it xm s3m)
---------------------------------------------------------
https://freebasic.net/forum/viewtopic.php?t=17740


Post by D.J.Peters - Apr 28, 2011 13:50
fbsound Version is 1.0 for Windows and Linux 32/64-bit
It's for free: Image;-)

https://shiny3d.de/public/fbsound/fbsound-1.0.zip
https://shiny3d.de/public/fbsound/fbsound-1.0-src.zip


