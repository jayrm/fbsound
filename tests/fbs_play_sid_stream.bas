'  ##############################
' # fbs_load_mp3file_mixer.bas #
'##############################
#include "../inc/fbsound_dynamic.bi"

#ifdef NOSID
 #error 666: sorry no sid decoder !
#endif

' example of:
' fbs_Create_SIDStream()
' fbs_Play_SIDStream()
' fbs_End_SIDStream()
const data_path = "../data/"
chdir(exepath())

' only if not same as exe path
' fbs_Set_PlugPath("./")

const Filename = "test.sid"
dim as boolean ok

ok=fbs_Init()
if ok=false then
  ? "error: fbs_Init() !"
  ? fbs_Get_PlugError()
  beep:sleep:end 1
end if

ok=FBS_Create_SIDStream(data_path & Filename)
if ok=false then
  ? "error: fbs_Create_SIDStream( '" & data_path & Filename & "') !"
  beep:sleep:end 1  
end if

ok=FBS_Play_SIDStream()
if ok=false then
  ? "error: fbs_Play_SIDStream() !"
  beep:sleep:end 1  
end if

'
' main loop

print "playing " & Filename
print "press any key ..."
sleep
fbs_End_SIDStream()
