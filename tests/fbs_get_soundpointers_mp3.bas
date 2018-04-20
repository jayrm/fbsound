'  #################################
' # fbs_get_soundpointers_mp3.bas #
'#################################
#include "../inc/fbsound.bi"

' example for:
' fbs_Get_WavePointers(hWave,[@lpStart],[@lpEnd],[@nChannels])
' fbs_Get_SoundPointers(hSound,[@lpStart],[@lpPlay],[@lpEnd])

' see "fbs_set_soundpointers.bas" for:
' fbs_Set_SoundPointers(hSound,[@lpStart],[@lpPlay],[@lpEnd])

const data_path = "../data/"
chdir(exepath())

' only if not same as exe path
' fbs_Set_PlugPath("./")

screenres 512,480

fbs_Init()
dim as integer        hWave,hSound
dim as FBS_SAMPLE ptr lpStart,lpEnd,lpOld,lpPlay
dim as integer        nSamples,nChannels,x,x_max,index,r_max,l_max
dim as FBS_SAMPLE     l,r

? "wait while decode whole MP3 in memory."
fbs_Load_MP3File(data_path & "legends.mp3",@hWave)

' get Number of Channels from loaded WAV/MP3
fbs_Get_WavePointers(hWave,,,@nChannels)

' create sound object from wave object
fbs_Create_Sound(hWave,@hSound)

' start hSound
fbs_Play_Sound(hSound)


x_max=511
while inkey<>chr(27)
  ' get curent play position
  fbs_Get_SoundPointers(hSound,,@lpPlay)
  ' draw only new samples
  if (lpOld<>lpPlay) then
    l_max=0:r_max=0
    screenlock:cls
    line (x_max,240)-(0,240),15
    index=0
    for x=0 to x_max
      l=lpPlay[index]:index+=nChannels
      l_max+=abs(l)
      l shr=5
      line -(x,240+l),1
    next
    l_max shr=12
    line (0,459)-step(l_max,8),3,bf

    if nChannels>1 then
      index=1:pset(0,240),15
      for x=0 to x_max
        r=lpPlay[index]:index+=nChannels
        r_max+=abs(r)
        r shr=5
        line -(x,240+r),4
      next
      r_max shr=12
      line (0,469)-step(r_max,8),4,bf
    end if
    screenunlock
    lpOld=lpPlay
  else
    ' no new samples wait a litle bit
    sleep 10
  end if
wend
end
