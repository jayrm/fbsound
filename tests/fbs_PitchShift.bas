'  ######################
' # fbs_pitchshift.bas #
'######################

#include "../inc/fbsound_dynamic.bi"

' Example: user defined MasterCallback() and realtime pitch shifting !

' fbs_PichShift()
' fbs_Set_MasterCallback()
' fbs_Enable_MasterCallback()
' fbs_Disable_MasterCallback()

' In this example i use the master callback again
' It is the Buffer with samples after the mixer pipeline

' This is an time indepented pitch shifter from -1 octave to +1 octave

const data_path = "../data/"
chdir(exepath())

' only if not same as exe path
' fbs_Set_PlugPath("./")

dim shared as integer globalNote

sub MyCallback(byval pSamples  as FBS_SAMPLE ptr, _
               byval nChannels  as integer, _
               byval nSamples   as integer)
  dim as single v
  v=fbs_pow(2,(globalNote)*(1.0/12.0))               
  fbs_PitchShift(pSamples,pSamples,v,nSamples)
end sub

'
' main
'
dim as boolean blnExit,blnFadeOut
dim as integer KeyCode,oldloops,loops,hWave,hSound
dim as single  MainVolume
dim as string  Key

fbs_Init()
fbs_Load_MP3File(data_path & "010.mp3",@hWave)
fbs_Create_Sound(hWave,@hSound)
fbs_Get_MasterVolume(@MainVolume)
fbs_Set_MasterCallback(@MyCallback)

globalNote=-6
fbs_Enable_MasterCallback()
fbs_play_Sound(hSound,25)

'
' main loop
'
? "Time independent frequency shift! [esc]=quit"
#ifdef __FB_64BIT__
? "sorry in 64-bit mode fbs_PitchShift() is only a dummy i'm working on !"
#endif
' 
while (blnExit=False)
  Key=inkey()
  if (Key=chr(27)) and (blnFadeOut=false) then
    blnFadeOut=True
    ? "fade out and quit"
  end if
  if (blnFadeOut=true) then
    fbs_Get_MasterVolume(@MainVolume)
    if (MainVolume>0.0) then
      MainVolume-=0.01
      fbs_Set_MasterVolume(MainVolume)
    else
      blnExit=True
    end if
  end if
  fbs_get_SoundLoops(hSound,@loops)
  if (loops<>oldloops) and (blnFadeOut=false) then
    globalNote += iif(globalNote>=0,1,2)
    ? "key on piano relative to the original: " & str(globalNote)
    oldloops=loops
    if globalNote>2 then 
      blnFadeOut=true
      ? "fade out and quit"
    end if
  end if
  sleep 50
wend

