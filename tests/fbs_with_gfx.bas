'  ####################
' # fbs_with_gfx.bas #
'####################
#include "../inc/fbsound.bi"

const data_path = "../data/"
chdir(exepath())

' only if not same as exe path
' fbs_Set_PlugPath("./")

const scr_w = 640
const scr_h = 480

#define noiseWidth  128
#define noiseHeight 128
#define mapsize     512
dim shared as single  noise(noiseWidth-1,noiseHeight-1)
dim shared as byte    highmap(mapsize-1,mapsize-1)
dim shared as integer yproj(-127 to 127,256)
function Noise2D(byval x as single, byval y as single) as single
   dim as single  fx,fy,v
   dim as integer x1,y1,x2,y2
   fX = x-int(x)
   fY = y-int(y)
   x1 = (int(x) + noiseWidth ) :x1 and = (noiseWidth -1)
   y1 = (int(y) + noiseHeight) :y1 and = (noiseHeight-1)
   x2 = x1 + (noiseWidth  - 1) :x2 and = (noiseWidth -1)
   y2 = y1 + (noiseHeight - 1) :y2 and = (noiseHeight-1)
   v += fX     * fY     * noise(x1,y1)
   v += fX     * (1-fY) * noise(x1,y2)
   v += (1-fX) * fY     * noise(x2,y1)
   v += (1-fX) * (1-fY) * noise(x2,y2)
   return v
end function

function Turbulence2D(byval x as single, _
                      byval y as single, _
                      byval s as single) as single
  dim as single v,olds=s*1.6
  while(s>=1.0)
   v+=Noise2D(x/s,y/s) * s
   s*=0.5
  wend 
  return v/olds
end function

sub init() constructor
  dim as integer x,y,z
  for x=0 to noiseWidth-1
    for y=0 to noiseHeight-1
      noise(x,y)=Rnd()
    next
  next
  for z=0 to mapsize\2
    for x=0 to mapsize\2
      y=Turbulence2D(x,z,128)*127
      'if y<0 then y=0
      'if y>127 then y=127
      highmap(            x,            z)=y
      highmap((mapsize-1)-x,            z)=y
      highmap(            x,(mapsize-1)-z)=y
      highmap((mapsize-1)-x,(mapsize-1)-z)=y
    next
  next
  for z=1 to 256
    for y=-127 to 127
      x=y * 128
      x\=z
      x+=100
      yproj(y,z)=x
    next
  next 
end sub

sub DrawFrame(byval xp  as single, _
              byval zp  as single, _
              byval ang as single)
  dim as single   a,astep,c,s,co,si
  dim as integer  x,y,xr,xpf,yr,zpf,cof,sif,cf,sf,ys,zr,yp,col,r
  dim as ubyte ptr curstart,curmem,curend=screenptr()
  if curend=0 then exit sub
  curstart=curend
  curstart+=scr_w*(scr_h-1) ' from bottom
  curend  +=scr_w*  8 ' to top
  ' get the hight from observer
  c=cos(ang):s=sin(ang)
  xr=xp+c*20:xr and=511
  zr=zp+s*20:zr and=511
  yp=highmap(xr,zr)+16
  xpf=xp*(1 shl 16)
  zpf=zp*(1 shl 16)
  ang-=0.5:astep=1/scr_w
  'scan the map for every pixel
  for x=0 to scr_w-1
    y=0:curmem=curstart
    c=cos(ang):s=sin(ang)
    co=c*20:si=s*20
    cof=xpf+co*(1 shl 16):cf=c*(1 shl 16)
    sif=zpf+si*(1 shl 16):sf=s*(1 shl 16)
    ' scale the ray inside the high map
    for r=1 to 256
      xr=(cof shr 16) and 511
      zr=(sif shr 16) and 511
      yr=highmap(xr,zr):col=yr:yr-=yp
      yr=yproj(yr,r)
      while (y<yr)
        *curmem=col:curmem-=scr_w:y+=1
        if curmem<curend then exit for
      wend
      cof+=cf:sif+=sf
    next
    ang+=astep:curstart+=1:curend+=1
  next
end sub

'
' main
'
dim as double  last,now
dim as single  ang=0.1,angstep=0,speed=1
dim as single  x=mapsize\2,z=mapsize\2,r,g,b,w,cfstep=6.28/128
dim as integer KeyCode,fps,frames,i,col2
ScreenRes scr_w,scr_h ',,,1

if fbs_Init(22050) then
  if fbs_Create_MP3Stream(data_path & "legends.mp3") then
    fbs_Play_MP3Stream()
  end if
end if



w=33
'color table
for i=1 to 254
  r=sin(w)*0.5+0.5
  g=cos(w*1.125)*0.5+0.5
  b=sin(w*1.333)*0.5+0.5
  palette i,r*255,g*255,b*255
  w=w+cfstep
next
palette 255,255,255,255

last=timer
while keycode<>27
  screenlock:cls
  DrawFrame x,z,ang
  color 255:? "[esc]=quit [cursor]=move around FPS:" & str(fps)
  screenunlock

  keycode=fbs_Get_KeyCode()
  if keycode>0 then
    select case keycode
      case k_left :angstep-=0.0001
      case k_right:angstep+=0.0001
      case k_up   :speed  +=0.01
      case k_down :speed  -=0.01
    end select
  else
    sleep 10
  end if
  x+=cos(ang)*speed
  z+=sin(ang)*speed
  ang+=angstep
  frames+=1
  if frames=24 then
    now=timer
    fps=cint(24.0/(now-last))
    frames=0:swap now,last
  end if
wend
end
