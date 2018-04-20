'  ##############################
' # fbs_Get_KeyCode-window.bas #
'##############################
#include "../inc/fbsound.bi"

' example of: fbs_Get_KeyCode()
' Screen() or ScreenRes() should be used befor fbs_Init()

' fbs_Set_PlugPath()
' fbs_Init()
' fbs_Get_PlugError()
' fbs_Load_WAVFile()
' fbs_Play_Wave()

const data_path = "../data/"
chdir(exepath())

' only if not same as exe path
' fbs_Set_PlugPath("./")

screenres 640,480
windowtitle "quit=->[X]"
dim as boolean ok
ok=fbs_Init(48000)
if ok=false then
  ? "error: fbs_Init() !"
  ? FBS_Get_PlugError()
  beep:sleep:end 1
end if

dim as integer hWave
ok=fbs_Load_WAVFile(data_path & "fbsloop44.wav",@hWave)
if ok=false then
  ? "error: fbs_Load_WAVFile() !"
  beep:sleep:end 1
end if

'get next free playback channel or create one
ok=fbs_Play_Wave(hWave)
if ok=false then
  ? "error: fbs_Play_Wave() !"
  beep:sleep:end 1
end if

'
' main loop
'
? "[p] = begin new playback (4 loops)"
dim As FBS_KEYCODES KeyCode

while KeyCode<>K_WINDOW_CLOSE
  KeyCode=fbs_Get_KeyCode()
  if KeyCode=K_P then
    fbs_Play_Wave hWave,4 ' optional 4 times
  else
    sleep 100
  end if
wend
end
