'  ##########################
' # fbs_init_44_22_khz.bas #
'##########################
#include "../inc/fbsound.bi"
' example of reconfig the lib
' fbs_Init()
' fbs_Stop()
' fbs_Exit()

const data_path = "../data/"
chdir(exepath())

' only if not same as exe path
' fbs_Set_PlugPath("./")

? "init with 44KHz"
fbs_Init() ' 44100Hz. is default

dim as integer hWave
? "load and play fox.mp3 for 3 seconds"
fbs_Load_MP3File(data_path & "fox.mp3",@hWave)
fbs_PLay_Wave(hWave,4) ' loop 4 times
sleep 3000,1

? "stop":fbs_stop:sleep 1000,1
? "exit":fbs_exit:sleep 2000,1
? "init with 22KHz"
fbs_Init(22050) ' changing from 44.1 KHz to 22.05 KHz
? "load play rnb_loop.mp3 endless"
fbs_Load_MP3File(data_path & "rnb_loop.mp3",@hWave)
fbs_PLay_Wave(hWave,-1)
? "any key=quit"
sleep
end

