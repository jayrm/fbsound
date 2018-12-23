#include once "../inc/fbsound_oop.bi"

' device.volume

var Device  = SoundDevice()
var Samples = SampleBuffer("../data/fox.mp3")
var Sound   = SoundBuffer(Samples)
Sound.Play

print "wait on end of playback or press any key ..."
var w=0.0
while inkey()="" andalso Sound.PlayPosition()<1.0
  Device.Volume = 0.6+sin(w)*0.4 : w+=0.01
  sleep 10,1
wend
