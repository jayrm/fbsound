#ifndef __FBS_PLUGOUT_DS__
#define __FBS_PLUGOUT_DS__

'  ##############
' # plug-ds.bi #
'##############
' Copyright 2005-2018 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "fbstypes.bi"

#ifndef NOPLUG_DS

' test of secondary DirectSoundBuffer
#include once "windows.bi"       ' <- BOOL, NULL ...
#include once "win/mmsystem.bi"  ' <- WAVEFORMETEX
#include once "win/d3dtypes.bi"  ' <- D3DVECTOR used in dsound.bi
#include once "win/dsound.bi"    ' <- IDirectSound

#inclib "dxguid"
#inclib "ole32"

#endif ' NOPLUG_DS

#endif ' __FBS_PLUGOUT_DS__
