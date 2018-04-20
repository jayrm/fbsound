'  ##############
' # fbscpu.bas #
'##############
' Copyright 2005-2018 by D.J.Peters (Joshy)
' d.j.peters@web.de

#include once "../inc/fbscpu.bi"

' BASIC fill n bytes with 0
private _
sub _ZeroBas(byval d as any ptr, _ ' destination
             byval n as integer)   ' n bytes
  memset(d,0,n)           
end sub

' ASM fill n bytes with 0
private _
sub _ZeroAsm(byval d as any ptr, _ ' destination
             byval n as integer)   ' n bytes
  asm
  mov    edi,[d]
  mov    ecx,[n]
  xor    eax,eax
  shr    ecx,1
  jnc    zeroasm_2
  stosb

zeroasm_2:
  shr    ecx,1
  jnc    zeroasm_4
  stosw

zeroasm_4:
  jecxz  zeroasm_end

zeroasm_loop:
  stosd
  dec    ecx
  jnz    zeroasm_loop
zeroasm_end:
  end asm
end sub

private _
sub _ZeroBuffer(byval s as any ptr    , _ ' source
                byval p as any ptr ptr, _ ' byref play pointer
                byval e as any ptr    , _ ' end pointer
                byval n as integer)       ' n bytes
  asm
  mov esi,[p]
  mov edi,[esi] '*ppPlay
  mov ecx,[n]
  mov ebx,[s]
  mov edx,[e]
  xor eax,eax
zerobuffer_set:         ' while n>0
  mov [edi],al          '   *p=0
  inc edi               '   p+=1
  cmp edi,edx           '   if p>=e then ...
  jge zerobuffer_reset
  
  dec ecx
  jnz zerobuffer_set
  jmp zerobuffer_end

zerobuffer_reset:
  mov edi,ebx           '   ... p=e
  dec ecx               '   n-=1
  jnz zerobuffer_set    ' wend 

zerobuffer_end:
  mov [esi],edi 'lpPlay=new pos
  end asm
end sub

' BASIC copy n bytes
private _
sub _CopyBas(byval d as any ptr, _ ' destination
             byval s as any ptr, _ ' source
             byval n as integer)   ' n bytes
  memcpy(d,s,n)
end sub

' ASM copy n bytes
private _
sub _CopyAsm(byval d as any ptr, _ ' destination
             byval s as any ptr, _ ' source
             byval n as integer)   ' n bytes
asm
  mov    edi,dword ptr [d]
  mov    esi,dword ptr [s]
  mov    ecx,dword ptr [n]

  shr    ecx,1
  jnc    copyasm_2
  movsb
  jecxz  copyasm_end

copyasm_2:
  shr    ecx,1
  jnc    copyasm_4
  movsw

copyasm_4:
  jecxz  copyasm_end

copyasm_loop:
  movsd
  dec    ecx
  jnz    copyasm_loop
copyasm_end:
  end asm
end sub

' ASM MMX copy n bytes
private _
sub _CopyMmx(byval d as any ptr, _ ' destination
             byval s as any ptr, _ ' source
             byval n as integer)   ' n bytes
  asm
  mov   edi,dword ptr [d]
  mov   esi,dword ptr [s]
  mov   ecx,dword ptr [n]

  shr   ecx,1
  jnc   copymmx_2
  movsb

copymmx_2:
  shr   ecx,1
  jnc   copymmx_4
  movsw

copymmx_4:
  shr   ecx,1
  jnc   copymmx_8
  movsd

copymmx_8:
  shr   ecx,1
  jnc   copymmx_16
  movq  mm0,[esi]
  movq  [edi],mm0
  add   esi,8
  add   edi,8

copymmx_16:
  shr   ecx,1
  jnc   copymmx_32
  movq  mm0,[esi]
  movq  [edi],mm0
  movq  mm0,[esi+8]
  movq  [edi+8],mm0
  lea   esi,[esi+16]
  lea   edi,[edi+16]

copymmx_32:
  shr   ecx,1
  jnc   copymmx_64
  movq  mm0,[esi]
  movq  [edi],mm0
  movq  mm0,[esi+8]
  movq  [edi+8],mm0
  movq  mm0,[esi+16]
  movq  [edi+16],mm0
  movq  mm0,[esi+24]
  movq  [edi+24],mm0
  lea   esi,[esi+32]
  lea   edi,[edi+32]

copymmx_64:
  jecxz copymmx_end

  copymmx_loop:
    movq   mm0,[esi]
    movq   [edi   ],mm0
    movq   mm1,[esi+ 8]
    movq   [edi+ 8],mm1
    movq   mm2,[esi+16]
    movq   [edi+16],mm2
    movq   mm3,[esi+24]
    movq   [edi+24],mm3
    movq   mm4,[esi+32]
    movq   [edi+32],mm4
    movq   mm5,[esi+40]
    movq   [edi+40],mm5
    movq   mm6,[esi+48]
    movq   [edi+48],mm6
    movq   mm7,[esi+56]
    movq   [edi+56],mm7
    lea    esi,[esi+64]
    lea    edi,[edi+64]
    dec ecx
  jnz copymmx_loop

  copymmx_end:
  emms
end asm
end sub

' ASM SSE copy n bytes
private _
sub _CopySse(byval d as any ptr, _ ' destination
             byval s as any ptr, _ ' source
             byval n as integer)   ' n bytes
  asm
  mov   edi,dword ptr [d]
  mov   esi,dword ptr [s]
  mov   ecx,dword ptr [n]

  shr   ecx,1
  jnc   copysse_2
  movsb

copysse_2:
  shr   ecx,1
  jnc   copysse_4
  movsw

copysse_4:
  shr   ecx,1
  jnc   copysse_8
  movsd

copysse_8:
  shr   ecx,1
  jnc   copysse_16
  movq  mm0,[esi  ]
  movq  [edi],mm0
  lea   esi,[esi+8]
  lea   edi,[edi+8]

copysse_16:
  shr   ecx,1
  jnc   copysse_32
  movq  mm0,[esi   ]
  movq  [edi  ],mm0
  movq  mm0,[esi+ 8]
  movq  [edi+8],mm0
  lea   esi,[esi+16]
  lea   edi,[edi+16]

copysse_32:
  shr   ecx,1
  jnc   copysse_64
  movq  mm0,[esi   ]
  movq  [edi  ],mm0
  movq  mm0,[esi+ 8]
  movq  [edi+8],mm0
  movq  mm0,[esi+16]
  movq  [edi+16],mm0
  movq  mm0,[esi+24]
  movq  [edi+24],mm0
  lea   esi,[esi+32]
  lea   edi,[edi+32]

copysse_64:
  jecxz copysse_end
  copysse_loop:
    movq   mm0,[esi+ 0]
    movntq [edi+ 0],mm0
    movq   mm1,[esi+ 8]
    movntq [edi+ 8],mm1
    movq   mm2,[esi+16]
    movntq [edi+16],mm2
    movq   mm3,[esi+24]
    movntq [edi+24],mm3
    movq   mm4,[esi+32]
    movntq [edi+32],mm4
    movq   mm5,[esi+40]
    movntq [edi+40],mm5
    movq   mm6,[esi+48]
    movntq [edi+48],mm6
    movq   mm7,[esi+56]
    movntq [edi+56],mm7
    lea    esi,[esi+64]
    lea    edi,[edi+64]
    dec ecx
  jnz copysse_loop

  copysse_end:
  emms
  end asm
end sub

' ASM mix two mono channels
private _
sub _mixAsm16(byval d as any ptr, _ ' destination
              byval a as any ptr, _ ' channel a
              byval b as any ptr, _ ' channel b
              byval n as integer)   ' n samples
  asm
  mov edi,dword ptr[d]
  mov esi,dword ptr[a]
  mov ebx,dword ptr[b]
  mov ecx,dword ptr[n]
  xor edx,edx

mixasm16loop:
  mov ax, word ptr [esi+edx] ' chna
  add ax, word ptr [ebx+edx] ' chnb
  jo mixasm16testc
  mov word ptr [edi+edx],ax
  add edx,2
  cmp edx,ecx
  jb  mixasm16loop
  jmp mixasm16end

mixasm16testc:
  jc  mixasm16savemin
  mov word ptr [edi+edx],&H7FFF ' +32767
  add edx,2
  cmp edx,ecx
  jb  mixasm16loop
  jmp mixasm16end

mixasm16savemin:
  mov word ptr [edi+edx],&H8000 ' -32768
  add edx,2
  cmp edx,ecx
  jb mixasm16loop
mixasm16end:
  end asm
end sub

' ASM MMX mix two mono channels
private _
sub _mixMmx16(byval d as any ptr, _ ' destination
              byval a as any ptr, _ ' channel a
              byval b as any ptr, _ ' channel b
              byval n as integer)   ' n samples
asm
  mov  edi,dword ptr [d]
  mov  esi,dword ptr [a]
  mov  ebx,dword ptr [b]
  mov  ecx,dword ptr [n]
  sub  ecx,8
  xor  edx,edx
  jmp  mixmmx16loop

mixmmx16add:
  add    edx, 8
mixmmx16loop:
  movq   mm0, [esi+edx] '     chna 4 words
  paddsw mm0, [ebx+edx] ' add chnb 4 words
  movq   [edi + edx], mm0
  cmp    edx, ecx
  jb     mixmmx16add
  emms
end asm
end sub
' ASM scale a mono channels
private _
sub _ScaleAsm16(byval d as any ptr, _ ' destination
                byval s as any ptr, _ ' source
                byval v as single , _ ' volume
                byval n as integer)   ' n samples
  dim mul32 as integer = (1 shl 16)
  asm
  fild   dword ptr [mul32]
  fld    dword ptr [v]
  fmulp
  fistp  dword ptr [mul32]

  mov    edi,[d]
  mov    esi,[s]
  mov    ecx,[n]
  sub    ecx,2

  push   ebp
  mov    ebp,dword ptr [mul32]
  xor    ebx,ebx
  jmp    scaleasm16_start

scaleasm16_add:
  add    ebx,2
scaleasm16_start:
  movsx  eax,word ptr [esi+ebx]
  imul   ebp
  jo     scaleasm16_min
  shr    eax,16
  mov    word ptr [edi+ebx],ax
  cmp    ebx,ecx
  jb     scaleasm16_add
  jmp    scaleasm16_end

scaleasm16_min:
  and    edx,edx
  jz     scaleasm16_max
  mov    word ptr [edi+ebx],&H8000 ' -32768
  cmp    ebx,ecx
  jb     scaleasm16_add
  jmp    scaleasm16_end

scaleasm16_max:
  mov    word ptr [edi+ebx],&H7fff ' +32767
  cmp    ebx,ecx
  jb     scaleasm16_add

scaleasm16_end:
  pop ebp
  end asm
end sub

private _
sub _PanLeftAsm16(byval d as any ptr, _ ' destination
                  byval s as any ptr, _ ' source
                  byval l as single , _ ' left paning
                  byval n as integer)   ' n samples
  dim mul32 as integer = l*(1 shl 16)
  asm
  mov    edi,[d]
  mov    esi,[s]
  mov    ecx,[n]
  sub    ecx,4

  push   ebp
  mov    ebp,dword ptr [mul32]
  xor    ebx,ebx
  jmp    panleftasm16_start

panleftasm16_add:
  add    ebx,4
panleftasm16_start:
  movsx  eax,word ptr [esi+ebx] ' get left
  imul   ebp                    ' scale left
  jo     panleftasm16_min
  shr    eax,16
  mov    [edi+ebx],ax           ' set left
  mov    ax,[esi+ebx+2]         ' get right  
  mov    [edi+ebx+2],ax         ' set right
  cmp    ebx,ecx
  jb     panleftasm16_add
  jmp    panleftasm16_end

panleftasm16_min:
  and    edx,edx
  jz     panleftasm16_max
  mov    word ptr [edi+ebx],&H8000 ' -32768 set left
  mov    ax,[esi+ebx+2]            ' get right  
  mov    [edi+ebx+2],ax            ' set right
  cmp    ebx,ecx
  jb     panleftasm16_add
  jmp    panleftasm16_end

panleftasm16_max:
  mov    word ptr [edi+ebx],&H7fff ' +32767 set left
  mov    ax,[esi+ebx+2]            ' get right  
  mov    [edi+ebx+2],ax            ' set right
  cmp    ebx,ecx
  jb     panleftasm16_add

panleftasm16_end:
  pop ebp
  end asm
end sub

private _
sub _PanRightAsm16(byval d as any ptr, _ ' destination
                   byval s as any ptr, _ ' source
                   byval r as single,  _ ' right paning
                   byval n as integer)   ' n samples
  dim mul32 as integer = r*(1 shl 16)
  asm
  mov    edi,[d]
  mov    esi,[s]
  mov    ecx,[n]
  sub    ecx,4

  push   ebp
  mov    ebp,dword ptr [mul32]
  xor    ebx,ebx
  jmp    panrightasm16_start

panrightasm16_add:
  add    ebx,4
panrightasm16_start:
  movsx  eax,word ptr [esi+ebx+2] ' get right
  imul   ebp                    ' scale right
  jo     panrightasm16_min
  
  shr    eax,16
  mov    [edi+ebx+2],ax         ' set right
  mov    ax,[esi+ebx]           ' get left  
  mov    [edi+ebx],ax           ' set left
  cmp    ebx,ecx
  jb     panrightasm16_add
  jmp    panrightasm16_end

panrightasm16_min:
  and    edx,edx
  jz     panrightasm16_max
  mov    word ptr [edi+ebx+2],&H8000 ' -32768 set right
  mov    ax,[esi+ebx]            ' get left  
  mov    [edi+ebx],ax            ' set left
  cmp    ebx,ecx
  jb     panrightasm16_add
  jmp    panrightasm16_end

panrightasm16_max:
  mov    word ptr [edi+ebx+2],&H7fff ' +32767 set right
  mov    ax,[esi+ebx]            ' get left  
  mov    [edi+ebx],ax            ' set left
  cmp    ebx,ecx
  jb     panrightasm16_add

panrightasm16_end:
  pop ebp
  end asm
end sub

private _
function _ReadEFLAG() as uinteger
  asm pushfd  'eflag on stack
  asm pop eax 'in eax
  asm mov [function],eax
end function

private _
sub _WriteEFLAG(byval v as uinteger)
  asm mov eax,[v]
  asm push eax 'value on stack
  asm popfd    'pop in eflag
end sub

private _
function _IsCPUID() as boolean 'CPUID command aviable
#ifndef __FB_64BIT__
  dim as uinteger _old,_new
  _old = _readeflag()
  _new = _old xor &H200000 'change bit 21
  _writeeflag _new
  _new = _readeflag()
  if _old<>_new then
    function = true
    _writeeflag _old 'restore old value
  end if
#else
  return false
#endif  
end function 

private _
function _TSC() as longint
  asm
    rdtsc
#ifndef __FB_64BIT__
    mov [function],eax
    mov [function+4],edx
#else    
    shl rdx, 32
    or  rax, rdx
    mov [function],rax
#endif    
  end asm
end function


private _
function _CPUIDEAX(byval nr as integer) as integer
  asm mov eax,[nr]
  asm cpuid
  asm mov [function],eax
end function 

private _
function _CPUIDEDX(byval nr as integer) as integer
  asm mov eax,[nr]
  asm cpuid
  asm mov [function],edx
end function 

'  ###############
' # 16 bit mono #
'###############
' copy samples and move the play pointer (speed is 1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopyRightAsm16(byval d as any ptr    , _ ' copy to destination
                    byval s as any ptr    , _ ' start of first sample
                    byval p as any ptr ptr, _ ' byref play pointer
                    byval e as any ptr    , _ ' end pointer
                    byval l as integer ptr, _ ' byref loop pointer
                    byval n as integer)       ' n bytes
  dim as integer loops
  asm
  mov edi,[d] 
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  mov ebx,[s]
  mov edx,[e]
  and edx,&HFFFFFFFE

  copy_right_asm16_get:
    mov ax,[esi]
    mov [edi],ax
    add edi,2
    add esi,2
    cmp esi,edx
    jge copy_right_asm16_reset
    dec ecx
    jnz copy_right_asm16_get
    jmp copy_right_asm16_end

  copy_right_asm16_reset:
    dec dword ptr [loops]
    jz  copy_right_asm16_fill 
    sub esi,edx
    add esi,ebx
    dec ecx
    jnz copy_right_asm16_get
    jmp copy_right_asm16_end

copy_right_asm16_fill:
  xor ax,ax
copy_right_asm16_fillloop:
  mov [edi],ax
  add edi,2
  dec ecx
  jnz copy_right_asm16_fillloop

copy_right_asm16_end:
  mov edi,[p]
  mov [edi],esi
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax
  end asm
end sub
' move only the play pointer (speed is <>1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveRightAsm16(byval s as any ptr    , _ ' start of first sample
                    byval p as any ptr ptr, _ ' byref play pointer
                    byval e as any ptr    , _ ' end pointer
                    byval l as integer ptr, _ ' byref loop pointer
                    byval n as integer)       ' n bytes
  dim as integer loops
  asm
  mov esi,[l]
  mov edi,[esi] ' *l
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  mov ebx,[s]
  mov edx,[e]
  and edx,&HFFFFFFFE

  move_right_asm16_get:
    add esi,2
    cmp esi,edx
    jge move_right_asm16_reset
    dec ecx
    jnz move_right_asm16_get
    jmp move_right_asm16_end

  move_right_asm16_reset:
    dec edi
    jz  move_right_asm16_end 
    sub esi,edx
    add esi,ebx
    dec ecx
    jnz move_right_asm16_get

move_right_asm16_end:
  mov eax,[p]
  mov [eax],esi
  mov eax,[l]
  mov [eax],edi
  end asm
end sub
' copy samples and move the play pointer (speed is <>1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopySliceRightAsm16(byval d as any ptr    , _ ' copy to destination
                         byval s as any ptr    , _ ' start of first sample
                         byval p as any ptr ptr, _ ' byref play pointer 
                         byval e as any ptr    , _ ' end pointer
                         byval l as integer ptr, _ ' byref loop pointer
                         byval v as single     , _ ' value of speed
                         byval n as integer)       ' n bytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))
  asm
  mov edi,[d] 
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  xor ebx,ebx

  copy_sliceright_asm16_get:
    mov ax,[esi]
  copy_sliceright_asm16_set:
    mov [edi],ax
    add edi,2
    add ebx,dword ptr [speed] ' value+=step
    mov edx,ebx
    and ebx,&HFFFF
    shr edx,15     ' words
    and edx,&HFFFE
    jnz copy_sliceright_asm16_add
    dec ecx
    jnz copy_sliceright_asm16_set
    jmp copy_sliceright_asm16_end

  copy_sliceright_asm16_add:
    add esi,edx    ' add only N*2 (words)
    mov eax,[e]
    and eax,&HFFFFFFFE
    cmp esi,eax
    jge copy_sliceright_asm16_reset
    dec ecx
    jnz copy_sliceright_asm16_get
    jmp copy_sliceright_asm16_end

  copy_sliceright_asm16_reset:
    dec dword ptr [loops]
    jz  copy_sliceright_asm16_fill 
    sub esi,eax
    add esi,dword ptr [s]
    dec ecx
    jnz copy_sliceright_asm16_get
    jmp copy_sliceright_asm16_end

copy_sliceright_asm16_fill:
  xor ax,ax
copy_sliceright_asm16_fillloop:
  mov [edi],ax
  add edi,2
  dec ecx
  jnz copy_sliceright_asm16_fillloop

copy_sliceright_asm16_end:
  mov edi,[p]
  mov [edi],esi
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax
  end asm
end sub

' copy samples and move the play pointer in reverse direction (speed is <>1.0)
' if the play pointer reached the start of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopySliceLeftAsm16(byval d as any ptr    , _ ' copy to destination
                        byval s as any ptr    , _ ' start of first sample
                        byval p as any ptr ptr, _ ' byref play pointer
                        byval e as any ptr    , _ ' end pointer
                        byval l as integer ptr, _ ' byref loop pointer
                        byval v as single     , _ ' value of speed
                        byval n as integer)       ' n bytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))
  asm
  mov edi,[d] 
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  xor ebx,ebx

  copy_sliceleft_asm16_get:
    mov ax,[esi]
  copy_sliceleft_asm16_set:
    mov [edi],ax
    add edi,2
    add ebx,dword ptr [speed] ' value+=step
    mov edx,ebx
    and ebx,&HFFFF
    shr edx,15     ' words
    and edx,&HFFFE
    jnz copy_sliceleft_asm16_sub
    dec ecx
    jnz copy_sliceleft_asm16_set
    jmp copy_sliceleft_asm16_end

  copy_sliceleft_asm16_sub:    
    sub esi,edx    ' sub only N*4 (dwords)
    mov eax,[s]
    and eax,&HFFFFFFFE
    cmp esi,eax
    jle copy_sliceleft_asm16_reset
    dec ecx
    jnz copy_sliceleft_asm16_get
    jmp copy_sliceleft_asm16_end

  copy_sliceleft_asm16_reset:
    dec dword ptr [loops]
    jz  copy_sliceleft_asm16_fill 
    sub esi,eax
    add esi,dword ptr [e]
    dec ecx
    jnz copy_sliceleft_asm16_get
    jmp copy_sliceleft_asm16_end

copy_sliceleft_asm16_fill:
  xor ax,ax
copy_sliceleft_asm16_fillloop:
  mov [edi],ax
  add edi,2
  dec ecx
  jnz copy_sliceleft_asm16_fillloop

copy_sliceleft_asm16_end:
  mov edi,[p]
  mov [edi],esi
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax
  end asm
end sub

' only move the play pointer (speed is <>1.0)
' if the play pointer reached the end pointer
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveSliceRightAsm16(byval s as any ptr    , _ ' start of first sample
                         byval p as any ptr ptr, _ ' byref play pointer
                         byval e as any ptr    , _ ' end pointer
                         byval l as integer ptr, _ ' byref loop pointer
                         byval v as single     , _ ' value of speed
                         byval n as integer)       ' n bytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))
  asm
  mov edi,[e]
  and edi,&HFFFFFFFE 
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  mov edx,[speed]
  xor ebx,ebx

  move_sliceright_asm16_get:
    add ebx,edx
    mov eax,ebx
    and ebx,&HFFFF
    shr eax,15     ' words
    and eax,&HFFFE
    jnz move_sliceright_asm16_add
    dec ecx
    jnz move_sliceright_asm16_get
    jmp move_sliceright_asm16_end

  move_sliceright_asm16_add:    
    add esi,eax    ' add only N*2 (words)
    cmp esi,edi
    jge move_sliceright_asm16_reset
    dec ecx
    jnz move_sliceright_asm16_get
    jmp move_sliceright_asm16_end

  move_sliceright_asm16_reset:
    dec dword ptr [loops]
    jz  move_sliceright_asm16_end 
    sub esi,edi
    add esi,dword ptr [s]
    dec ecx
    jnz move_sliceright_asm16_get

move_sliceright_asm16_end:
  mov edi,[p]
  mov [edi],esi
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax
  end asm
end sub

' only move the play pointer in reverse direction (speed is <>1.0)
' if the play pointer reached the start pointer
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveSliceLeftAsm16(byval s as any ptr    , _ ' pStart
                        byval p as any ptr ptr, _ ' @pPlay
                        byval e as any ptr    , _ ' pEnd
                        byval l as integer ptr, _ ' @nLoops
                        byval v as single     , _ ' value of speed
                        byval n as integer)       ' nBytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))
  asm
  mov edi,[s]
  and edi,&HFFFFFFFE
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,1 ' bytes to words
  mov edx,[speed]
  xor ebx,ebx

  move_sliceleft_asm16_get:
    add ebx,edx ' value+=step
    mov eax,ebx
    and ebx,&HFFFF
    shr eax,15     ' words
    and eax,&HFFFE
    jnz move_sliceleft_asm16_sub
    dec ecx
    jnz move_sliceleft_asm16_get
    jmp move_sliceleft_asm16_end

  move_sliceleft_asm16_sub:    
    sub esi,eax    ' sub only N*2 (words)
    cmp esi,edi
    jle move_sliceleft_asm16_reset
    dec ecx
    jnz move_sliceleft_asm16_get
    jmp move_sliceleft_asm16_end

  move_sliceleft_asm16_reset:
    dec dword ptr [loops]
    jz  move_sliceleft_asm16_end 
    sub esi,edi
    add esi,dword ptr [e]
    dec ecx
    jnz move_sliceleft_asm16_get

move_sliceleft_asm16_end:
  mov edi,[p]
  mov [edi],esi
  mov edi,[l]
  mov eax,[loops]
  mov [edi],eax
  end asm
end sub

'  #################
' # 16 bit stereo #
'#################
' copy samples and move the play pointer (speed is 1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopyRightAsm32(byval d as any ptr    , _ ' copy to destination
                    byval s as any ptr    , _ ' pStart
                    byval p as any ptr ptr, _ ' @pPlay
                    byval e as any ptr    , _ ' pEnd
                    byval l as integer ptr, _ ' @nLoops
                    byval n as integer)       ' nBytes
  dim as integer loops
  asm
  mov edi,[d] 
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,2 ' bytes to dwords
  mov ebx,[s]
  mov edx,[e]
  'and edx,&HFFFFFFFC

  copy_right_asm32_get:
    mov eax,[esi]
    mov [edi],eax
    add edi,4
    add esi,4
    cmp esi,edx                 ' playpointer >= end of samples
    jge copy_right_asm32_reset
    dec ecx
    jnz copy_right_asm32_get    ' more samples 
    jmp copy_right_asm32_end

  copy_right_asm32_reset:
    dec dword ptr [loops]       ' *nLoops-=1
    jz  copy_right_asm32_fill   ' if last loop fill rest of buffer with 0
    sub esi,edx                 ' pPlay -= pEnd
    add esi,ebx                 ' pPlay += pStart
    mov esi,ebx
    dec ecx
    jnz copy_right_asm32_get
    jmp copy_right_asm32_end

  copy_right_asm32_fill:
    xor eax,eax
  copy_right_asm32_fillloop:
    mov [edi],eax
    add edi,4
    dec ecx
    jnz copy_right_asm32_fillloop

  copy_right_asm32_end:
    mov edi,[p]
    mov [edi],esi               ' *pPlay = current pPlay
    mov edi,[l]
    mov eax,[loops]
    mov [edi],eax               ' *nLoops=loops
  end asm
end sub

' move only the play pointer (speed is 1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveRightAsm32(byval s as any ptr    , _ ' pStart
                    byval p as any ptr ptr, _ ' @pPlay
                    byval e as any ptr    , _ ' pEnd
                    byval l as integer ptr, _ ' @nLoops
                    byval n as integer)       ' nBytes
  dim as integer loops
  asm
    mov esi,[l]
    mov edi,[esi]                 ' *pLoops
    mov esi,[p]
    mov esi,[esi]                 ' *pPlay
    mov ecx,[n]                   ' nBytes  
    shr ecx,2                     ' bytes to dwords
    mov ebx,[s]                   ' pStart
    mov edx,[e]                   ' pEnd
    and edx,&HFFFFFFFC

  move_right_asm32_get:
    add esi,4                   ' pPay += 1
    cmp esi,edx
    jge move_right_asm32_reset  ' if pPlay >= pEnd then reset
    dec ecx                     ' nSamples -= 1
    jnz move_right_asm32_get      
    jmp move_right_asm32_end    ' if nSamples=0 then goto move_right_asm32_end

  move_right_asm32_reset:
    dec edi                     ' nLoops -= 1
    jz  move_right_asm32_end    ' if nLoops=0 then goto move_right_asm32_end
    sub esi,edx                 ' pPlay -= pEnd
    add esi,ebx                 ' pPlay += pStart
    dec ecx                     ' nSamples -= 1  
    jnz move_right_asm32_get    ' if nSamples>0 then goto move_right_asm32_get

  move_right_asm32_end:
    mov eax,[p]
    mov [eax],esi               ' *pPlay = current pPlay   
    mov eax,[l]
    mov [eax],edi               ' *pLoop = current nLoops   
  end asm
end sub

' copy STEREO samples and move the play pointer (speed is <>1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopySliceRightAsm32(byval d as any ptr    , _ ' pDestination
                         byval s as any ptr    , _ ' pStart
                         byval p as any ptr ptr, _ ' @pPlay
                         byval e as any ptr    , _ ' pEnd
                         byval l as integer ptr, _ ' @nLoops
                         byval v as single     , _ ' value of speed
                         byval n as integer    )   ' nBytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))       ' single to fixrd point 16.16
  asm
    mov edi,[d]                 ' destination buffer 
    mov esi,[l]                 ' ppLoops
    mov esi,[esi]               ' *pLoops get nLoops from ptr
    mov [loops],esi             ' save in local var loops
    mov esi,[p]                 ' pPlay
    mov esi,[esi]               ' esi = *pPlay
    mov ecx,[n]                 ' nBytes
    shr ecx,2                   ' bytes to dwords
    xor ebx,ebx                 ' var value=0

  copy_sliceright_asm32_get:
    mov eax,[esi]               ' get left and right channel from wave buffer
    
  copy_sliceright_asm32_set:
    mov [edi],eax               ' *cptr(long ptr,esi)=samples
    add edi,4                   ' esi += 4
    add ebx,dword ptr [speed]   ' value += step
    mov edx,ebx                 ' save value
    and ebx,&HFFFF              ' value and= 0000:FFFF
    shr edx,14                  ' 16:bytes 15:words 14:dwords
    and edx,&HFFFC
    jnz copy_sliceright_asm32_add
    
    dec ecx                      ' nSamples -= 1 
    jnz copy_sliceright_asm32_set
    jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_add:
    add esi,edx                 ' add only N*4 (dwords)
    mov eax,[e]
    and eax,&HFFFFFFFC
    cmp esi,eax                 
    jge copy_sliceright_asm32_reset ' if pPlay > pEnd then reset
    
    dec ecx
    jnz copy_sliceright_asm32_get
    jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_reset:
    dec dword ptr [loops]          ' nLoops -= 1 
    jz  copy_sliceright_asm32_fill ' if nLoops=0 then fill rest of buffer with 0
    sub esi,eax                    ' pPlay -= pEnd
    add esi,dword ptr [s]          ' pPlay += pStart
    dec ecx
    jnz copy_sliceright_asm32_get
    jmp copy_sliceright_asm32_end

  copy_sliceright_asm32_fill:
    xor eax,eax
  copy_sliceright_asm32_fillloop:
    mov [edi],eax
    add edi,4
    dec ecx
    jnz copy_sliceright_asm32_fillloop

  copy_sliceright_asm32_end:
    mov edi,[p]
    mov [edi],esi               ' pPlay=current pPlay
    mov edi,[l]
    mov eax,[loops]
    mov [edi],eax               ' *pLoops = nLoops
  end asm
end sub

' copy samples and move the play pointer in reverse direction (speed is < 0.0)
' if the play pointer reached the start of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _CopySliceLeftasm32(byval d as any ptr    , _ ' copy to destination
                        byval s as any ptr    , _ ' pStart
                        byval p as any ptr ptr, _ ' @pPlay
                        byval e as any ptr    , _ ' pEnd
                        byval l as integer ptr, _ ' @nLoops
                        byval v as single     , _ ' value of speed
                        byval n as integer)       ' nBytes
  dim as integer loops,speed
  v=abs(v)
  speed=v*(1 shl 16)
  asm
  mov edi,[d]
  mov esi,[l]
  mov esi,[esi]                 ' *pLoops
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi]                 ' *pPlay
  mov ecx,[n]                   ' nBytes
  shr ecx,2                     ' bytes to dwords
  xor ebx,ebx                   ' vvar value=0

  copy_sliceleft_asm32_get:
    mov eax,[esi]
  copy_sliceleft_asm32_set:
    mov [edi],eax
    add edi,4
    add ebx,dword ptr [speed] ' value+=step
    mov edx,ebx
    and ebx,&HFFFF
    shr edx,14                ' 16:bytes 15:words 14:dwords
    and edx,&HFFFC
    jnz copy_sliceleft_asm32_sub
    dec ecx
    jnz copy_sliceleft_asm32_set
    jmp copy_sliceleft_asm32_end

  copy_sliceleft_asm32_sub:
    sub esi,edx                ' pPlay -= step subtract only N*4 (dwords)
    mov eax,[s]
    and eax,&HFFFFFFFC
    cmp esi,eax
    jle copy_sliceleft_asm32_reset  ' if pPlay < pStart then goto copy_sliceleft_asm32_reset
    
    dec ecx                         ' nSamples-=1
    jnz copy_sliceleft_asm32_get
    jmp copy_sliceleft_asm32_end

  copy_sliceleft_asm32_reset:
    dec dword ptr [loops]           ' nLoops-=1
    jz  copy_sliceleft_asm32_fill   ' if nLoops=0 then fille rest of buffer with 0
    sub esi,eax                     ' pPlay -= pStart 
    add esi,dword ptr [e]           ' pPlay += pEnd
    dec ecx                         ' nSamples-=1
    jnz copy_sliceleft_asm32_get
    jmp copy_sliceleft_asm32_end

  copy_sliceleft_asm32_fill:
    xor eax,eax
  
  copy_sliceleft_asm32_fillloop:
    mov [edi],eax
    add edi,4
    dec ecx
    jnz copy_sliceleft_asm32_fillloop

  copy_sliceleft_asm32_end:
    mov edi,[p]
    mov [edi],esi
    mov edi,[l]
    mov eax,[loops]
    mov [edi],eax
  end asm
end sub

' only move the play pointer (speed is >0.0 and <1.0)
' if the play pointer reached the end of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveSliceRightasm32(byval s as any ptr    , _ ' pStart
                         byval p as any ptr ptr, _ ' @pPlay
                         byval e as any ptr    , _ ' pEnd
                         byval l as integer ptr, _ ' @nLoops
                         byval v as single     , _ ' value of speed
                         byval n as integer)       ' nBytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))
  asm
  mov edi,[e]
  and edi,&HFFFFFFFC 
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,2 ' bytes to dwords

  mov edx,[speed]
  xor ebx,ebx

  move_sliceright_asm32_get:
    add ebx,edx
    mov eax,ebx
    and ebx,&HFFFF
    shr eax,14     ' dwords
    and eax,&HFFFC
    jnz move_sliceright_asm32_add
    dec ecx
    jnz move_sliceright_asm32_get
    jmp move_sliceright_asm32_end

  move_sliceright_asm32_add:
    add esi,eax    ' add only N*4 (dwords)
    cmp esi,edi
    jge move_sliceright_asm32_reset
    dec ecx
    jnz move_sliceright_asm32_get
    jmp move_sliceright_asm32_end

  move_sliceright_asm32_reset:
    dec dword ptr [loops]
    jz  move_sliceright_asm32_end 
    sub esi,edi
    add esi,dword ptr [s]
    dec ecx
    jnz move_sliceright_asm32_get

  move_sliceright_asm32_end:
    mov edi,[p]
    mov [edi],esi
    mov edi,[l]
    mov eax,[loops]
    mov [edi],eax
  end asm
end sub

' only move the play pointer in reverse direction (speed is <>1.0)
' if the play pointer reached the start of samples
' the loop counter will be decremented
' and the play pointer must be new calculated
private _
sub _MoveSliceLeftasm32(byval s as any ptr    , _ ' pStart
                        byval p as any ptr ptr, _ ' @pPlay
                        byval e as any ptr    , _ ' pEnd
                        byval l as integer ptr, _ ' @nLoops
                        byval v as single     , _ ' value of speed
                        byval n as integer)       ' nBytes
  dim as integer loops,speed
  speed=abs(v*(1 shl 16))
  asm
  mov edi,[s]
  and edi,&HFFFFFFFC  
  mov esi,[l]
  mov esi,[esi] ' *l
  mov [loops],esi
  mov esi,[p]
  mov esi,[esi] ' *p
  mov ecx,[n]
  shr ecx,2 ' bytes to dwords
  mov edx,[speed]
  xor ebx,ebx

  move_sliceleft_asm32_get:
    add ebx,edx                 ' value+=step
    mov eax,ebx
    and ebx,&HFFFF
    shr eax,14                  ' 16:bytes 15:words 14:dwords
    and eax,&HFFFC
    jnz move_sliceleft_asm32_sub
    dec ecx
    jnz move_sliceleft_asm32_get
    jmp move_sliceleft_asm32_end

  move_sliceleft_asm32_sub:    
    sub esi,eax                 ' sub only N*4 (dwords)
    cmp esi,edi
    jle move_sliceleft_asm32_reset
    dec ecx
    jnz move_sliceleft_asm32_get
    jmp move_sliceleft_asm32_end

  move_sliceleft_asm32_reset:
    dec dword ptr [loops]         ' nLoop-=1
    jz  move_sliceleft_asm32_end  ' if nLoops=0 then goto move_sliceleft_asm32_end
    sub esi,edi
    add esi,dword ptr [e]
    dec ecx
    jnz move_sliceleft_asm32_get

  move_sliceleft_asm32_end:
    mov edi,[p]
    mov [edi],esi               ' *pPlay = cuttent play position
    mov edi,[l]
    mov eax,[loops]
    mov [edi],eax               ' *pLoop = current pLoop  
  end asm
end sub

#ifndef NOMP3

' copy samples from MP3 STEREO stream to the current play pointer (speed is 1.0)
' move the play pointer if it reached the end, reset it
private _
sub _CopyMP3FrameAsm(byval pStart   as any ptr    , _ ' pStart
                     byval pPlay    as any ptr ptr , _ ' @pPlay
                     byval pEnd     as any ptr    , _ ' pEnd
                     byval pSamples as any ptr    , _
                     byval nBytes   as integer)
  asm
  mov esi,[pSamples]
  mov edi,[pPlay]
  mov edi,[edi] 
  mov ecx,[nBytes]
  shr ecx,2                     ' bytes to dwords (stereo 16bit)   
  mov ebx,[pStart]
  mov edx,[pEnd]  

  copy_mp3frame_get:
    mov eax,[esi]
    mov [edi],eax
    add edi,4
    add esi,4
    cmp edi,edx                 ' if pPlay >= pEnd then reset pPlay
    jge copy_mp3frame_reset
    dec ecx
    jnz copy_mp3frame_get
    jmp copy_mp3frame_end

  copy_mp3frame_reset:
    mov edi,ebx                 ' pPlay = pStart  
    dec ecx
    jnz copy_mp3frame_get

  copy_mp3frame_end:
    mov esi,[pPlay]
    mov [esi],edi               ' *pPlay = current pPlay
  end asm
end sub

' Copy samples from MP3 STEREO stream to the current play pointer (speed<>1.0).
' Move the play pointer if it reached the end reset it.
private _
sub _CopySliceMP3FrameAsm32(byval pStart   as any ptr    , _ ' start of first sample
                            byval pPlay    as any ptr ptr, _ ' @pPlay
                            byval pEnd     as any ptr    , _ ' last sample
                            byval pSamples as any ptr    , _ ' source of mp3 samples
                            byval v        as single     , _ ' value of speed
                            byval nBytes   as integer  )     ' n bytes
  dim as integer speed=v*(1 shl 16) ' single to fixed point 16:16
  asm
  mov edi,[pPlay] 
  mov edi,[edi]
  mov esi,[pSamples]
  mov ecx,[nBytes] 
  shr ecx,2                     ' bytes to dwords
  xor ebx,ebx                   ' var value=0

  CopySliceStream32_get:
    mov eax,[esi]               ' get stereo 16bit samples

  CopySliceStream32_set:
    mov [edi],eax               ' put in destination buffer
    add  edi,4
    cmp edi,dword ptr [pEnd]
    jge CopySliceStream32_reset ' if pPlay >= pEnd then reset

  CopySliceStream32_calc:
    dec ecx                     ' nFrames-=1
    jz  CopySliceStream32_end   ' if nFrames=0 then goto end sub

    add ebx,dword ptr [speed]   ' value += step
    mov edx,ebx                 ' save value
    and ebx,&HFFFF              ' value and = 0000:FFFF
    shr edx,14                  ' 16:bytes 15:words 14:dwords
    and edx,&HFFFC              '  
    jnz CopySliceStream32_add
    jmp CopySliceStream32_set

  CopySliceStream32_add:    
    add esi,edx                 ' add only N*4 (dwords)
    jmp CopySliceStream32_get

  CopySliceStream32_reset:
    mov edi,[pStart]           ' pPlay = pStart  
    jmp CopySliceStream32_calc

CopySliceStream32_end:
  mov esi,[pPlay]             
  mov [esi],edi                 ' *pPlay = current pPlay
end asm
end sub

' copy samples from MP3 MONO stream to the current play pointer (speed<>1.0)
' move the play pointer if it reached the end reset it
private _
sub _CopySliceMP3FrameAsm16(byval pStart   as any ptr    , _ ' first sample
                            byval pPlay    as any ptr ptr, _ ' @pPlay
                            byval pEnd     as any ptr    , _ ' last sample
                            byval pSamples as any ptr    , _ ' source of MP3 samples
                            byval v        as single     , _ ' value of speed 
                            byval nBytes   as integer  )     ' nBytes
  dim as integer speed=v*(1 shl 16) ' single to fixed point 16.16
  asm
  mov edi,[pPlay] 
  mov edi,[edi]
  mov esi,[pSamples]
  mov ecx,[nBytes] 
  shr ecx,1                     ' nBytes to 16bit samples (words)
  xor ebx,ebx                   ' var value=0

  CopySliceMP3Frame16_get:
    mov ax,[esi]                ' get mono 16bit sample

  CopySliceMP3Frame16_set:
    mov [edi],ax                ' samples[pPlay]=ax
    add  edi,2                  ' pPlay+=2
    cmp edi,dword ptr [pEnd]    ' if pPlay>=pEnd then reset  
    jge CopySliceMP3Frame16_reset

  CopySliceMP3Frame16_calc:
    dec ecx                      ' nSamples-=1 : if nSamples=0 then goto CopySliceMP3Frame16_end:
    jz  CopySliceMP3Frame16_end

    add ebx,dword ptr [speed]   ' value+=step
    mov edx,ebx                 ' save value
    and ebx,&HFFFF              ' value and= 0000:FFFF
    shr edx,15                  ' 16:bytes 15:words 14:dwords
    and edx,&HFFFE              ' new address are a multiply of 2 (word)
    jnz CopySliceMP3Frame16_add
    jmp CopySliceMP3Frame16_set

  CopySliceMP3Frame16_add:    
    add esi,edx                 ' add only N*2 (words)
    jmp CopySliceMP3Frame16_get

  CopySliceMP3Frame16_reset:
    mov edi,[pStart]            ' pPlay=pStart
    jmp CopySliceMP3Frame16_calc

CopySliceMP3Frame16_end:
  mov esi,[pPlay]
  mov [esi],edi                 ' *pPlay = current pPlay
  end asm
end sub

#define MAD_F_ONE  &H10000000
#define MAD_F_MIN -MAD_F_ONE
#define MAD_F_MAX  MAD_F_ONE - 1

' none interleaved fixed point 32 bit stereo to stereo interleaved 16 bit
private  _
sub _ScaleMP3Frame_22_asm16(byval d  as any ptr , _
                            byval s1 as any ptr , _
                            byval s2 as any ptr , _
                            byval n  as integer  )
  asm
  mov edi,[d]
  mov esi,[s1]
  mov ebx,[s2]
  mov ecx,[n]

  ScaleMP3Frame_22_16_get_left:
    mov eax,[esi] ' left channel
    cmp eax,MAD_F_MAX
    jng ScaleMP3Frame_22_16_test_lmin
    
    mov word ptr [edi],&H7FFF
    jmp ScaleMP3Frame_22_16_get_right

  ScaleMP3Frame_22_16_test_lmin:
    cmp eax,MAD_F_MIN
    jnl ScaleMP3Frame_22_16_shift_left
    mov word ptr [edi],&H8000
    jmp ScaleMP3Frame_22_16_get_right

  ScaleMP3Frame_22_16_shift_left:
    shr eax,13                  ' mad fixed point value to 16:bit
    mov [edi],ax                ' samples[p]=ay

  ScaleMP3Frame_22_16_get_right:
    add edi,2                   ' p += 2
    mov eax,[ebx]               ' right channel
    cmp eax,MAD_F_MAX
    jng ScaleMP3Frame_22_16_test_rmin  
    mov word ptr [edi],&H7FFF     
    jmp ScaleMP3Frame_22_16_get_next
  
  ScaleMP3Frame_22_16_test_rmin:  
    cmp eax,MAD_F_MIN
    jnl ScaleMP3Frame_22_16_shift_right  
    mov word ptr [edi],&H8000
    jmp ScaleMP3Frame_22_16_get_next
  
  ScaleMP3Frame_22_16_shift_right:
    shr eax,13                  ' mad fixed point value to 16:bit 
    mov [edi],ax

  ScaleMP3Frame_22_16_get_next:
    add edi,2 ' next stero channel
    add esi,4 ' next dword left channel
    add ebx,4 ' next dword right channel
    dec ecx
    jnz ScaleMP3Frame_22_16_get_left
  end asm
end sub

' none interleaved fixed point 32 bit stereo to mono 16 bit
private _
sub _ScaleMP3Frame_21_asm16(byval d  as any ptr , _
                            byval s1 as any ptr , _
                            byval s2 as any ptr , _
                            byval n  as integer)
  asm
  mov edi,[d]
  mov esi,[s1]
  mov ebx,[s2]
  mov ecx,[n]

  ScaleMP3Frame_21_16_get_L:
    mov edx,[esi]               ' edx = left channel
    cmp eax,MAD_F_MAX
    jng ScaleMP3Frame_21_16_test_left_min
    mov edx,&H7fff
    jmp ScaleMP3Frame_21_16_get_R

  ScaleMP3Frame_21_16_test_left_min:
    cmp eax,MAD_F_MIN
    jnl ScaleMP3Frame_21_16_shift_left
    mov edx,&H8000
    jmp ScaleMP3Frame_21_16_get_R

  ScaleMP3Frame_21_16_shift_left:
    shr edx,13

  ScaleMP3Frame_21_16_get_R:
    mov eax,[ebx]               ' eax = right channel
    cmp eax,MAD_F_MAX
    jng ScaleMP3Frame_21_16_test_right_min
    mov eax,&H7fff
    jmp ScaleMP3Frame_21_16_get_next

  ScaleMP3Frame_21_16_test_right_min:
    cmp eax,MAD_F_MIN
    jnl ScaleMP3Frame_21_16_shift_right
    mov eax,&H8000
    jmp ScaleMP3Frame_21_16_get_next

  ScaleMP3Frame_21_16_shift_right:
    shr eax,13

  ScaleMP3Frame_21_16_get_next:
    add eax,edx                 ' 
    shr eax,2                   '  ax = (left + right)\2
    mov [edi],ax
    add edi,2
    add esi,4
    add ebx,4
    dec ecx
  jnz ScaleMP3Frame_21_16_get_L
  end asm
end sub

' fixed point 32 bit mono to stereo 16 bit
private _
sub _ScaleMP3Frame_12_asm16(byval d  as any ptr , _
                            byval s1 as any ptr , _
                            byval n  as integer)
  asm
  mov edi,[d]
  mov esi,[s1]
  mov ecx,[n]
  mov ebx,&H80008000
  mov edx,&H7FFF7FFF

  ScaleMP3Frame_12_16_get:
    mov eax,[esi]               ' 32 bit fixed mono channel
    cmp eax,MAD_F_MAX
    jng ScaleMP3Frame_12_16_test_min
    mov [edi],edx
    add edi,4
    add esi,4
    dec ecx
    jnz ScaleMP3Frame_12_16_get
    jmp ScaleMP3Frame_12_16_end

  ScaleMP3Frame_12_16_test_min:
    cmp eax,MAD_F_MIN
    jnl ScaleMP3Frame_12_16_shift
    mov [edi],ebx
    add edi,4
    add esi,4
    dec ecx
  jnz ScaleMP3Frame_12_16_get
  jmp ScaleMP3Frame_12_16_end

  ScaleMP3Frame_12_16_shift:
    shr eax,13
    mov [edi  ],ax
    mov [edi+2],ax
    add edi,4
    add esi,4
    dec ecx
  jnz ScaleMP3Frame_12_16_get

  ScaleMP3Frame_12_16_end:
  end asm
end sub

' fixed point 32 bit mono to mono 16 bit
private _
sub _ScaleMP3Frame_11_asm16(byval d  as any ptr , _
                            byval s1 as any ptr , _
                            byval n  as integer)
  asm
  mov edi,[d]
  mov esi,[s1]
  mov ecx,[n]
  mov bx,&H8000
  mov dx,&H7Fff   
  ScaleMP3Frame_11_16_get:
    mov eax,[esi]               ' 32 bit fixed point mono channel
    cmp eax,MAD_F_MAX
    jng ScaleMP3Frame_11_16_test_min
    mov [edi],dx
    add edi,2
    add esi,4
    dec ecx
    jnz ScaleMP3Frame_11_16_get
    jmp ScaleMP3Frame_11_16_end

  ScaleMP3Frame_11_16_test_min:
    cmp eax,MAD_F_MIN
    jnl ScaleMP3Frame_11_16_shift
    mov [edi],bx
    add edi,2
    add esi,4
    dec ecx
    jnz ScaleMP3Frame_11_16_get
    jmp ScaleMP3Frame_11_16_end

  ScaleMP3Frame_11_16_shift:
    shr eax,13
    mov [edi],ax
    add edi,2
    add esi,4
    dec ecx
    jnz ScaleMP3Frame_11_16_get
  ScaleMP3Frame_11_16_end:
  end asm
end sub
#endif

'  ##################
' # init cpu layer #
'##################
dim shared as FBS_CPU me


sub fbscpu_init() constructor
  dim as string   msg
  dim as long  ct,r
  dim as longint c1,c2,cd
  dim as double t1,t2,td
  dprint("cpu:()")

  if _IsCPUID()=true then
    r=_CPUIDEDX(1)
                              me.fpu =true:msg=      "FPU "
    if (r and &H0000010) then me.tsc =true:msg=msg & "TSC "
    if (r and &H0008000) then me.cmov=true:msg=msg & "CMOV "
    if (r and &H0800000) then me.mmx =true:msg=msg & "MMX "
    if (r and &H2000000) then me.sse =true:msg=msg & "SSE "
    if (r and &H4000000) then me.sse2=true:msg=msg & "SSEII "

    r=_CPUIDEAX(&H80000000)
    if ((r and &H80000000)=&H80000000) and ((r and &HFF)>0) then 
      r=_CPUIDEDX(&H80000001)
      if (r and &H00400000) then me.mmx2=true:msg=msg & "MMXII "
      if (r and &H80000000) then me.n3d =true:msg=msg & "3DNOW "
      if (r and &H40000000) then me.n3d2=true:msg=msg & "3DNOWII"
    end if
    dprint(msg)
    if me.tsc=true then
      me.cpucounter=@_TSC
      t1=timer()
      c1=me.cpucounter()
      while td<1.0:t2=timer:td=t2-t1:wend
      c2=me.cpucounter()
      cd=c2-c1
      cd\=1000000
      me.mhz=cint(cd*td)
      dprint("MHz~"+str(me.mhz))
    end if

    if me.sse=true then 
      me.copy=@_copysse ': dprint("copy(SSE)")
    elseif me.mmx=true then
      me.copy=@_copymmx ': dprint("copy(MMX)")
    else
      me.copy=@_copyasm ': dprint("copy(ASM)")
    end if

    if me.mmx=true then
      'dprint("mixer(MMX)")
      me.mix16=@_mixmmx16
    else
      'dprint("mixer(ASM)")
      me.mix16=@_mixasm16
    end if
    'dprint("zero, scale, shift, pan, dsp(ASM)")
    me.zero        =@_zeroasm   
    me.zerobuffer  =@_zerobuffer   
    me.scale16     =@_scaleasm16

    me.panleft16   =@_panleftasm16
    me.panright16  =@_panrightasm16

    me.copyright16 =@_copyrightasm16
    me.copyright32 =@_copyrightasm32
    me.moveright16 =@_moverightasm16
    me.moveright32 =@_moverightasm32

    me.copysliceright16 =@_copyslicerightasm16
    me.copysliceright32 =@_copyslicerightasm32
    me.movesliceright16 =@_moveslicerightasm16
    me.movesliceright32 =@_moveslicerightasm32

    me.copysliceleft16 =@_copysliceleftasm16
    me.copysliceleft32 =@_copysliceleftasm32
    me.movesliceleft16 =@_movesliceleftasm16
    me.movesliceleft32 =@_movesliceleftasm32

  else
  
    dprint("FPU")
    ct=1000000/2.25*100
    t1=timer()
    asm
    mov ecx,[ct]
    tloop:
    dec ecx
    cmp ecx,0
    jg tloop
    end asm
    t2=timer()
    td=t2-t1
    me.mhz=int(100.0/td)
    dprint("MHz~"+str(me.mhz))

    me.fpu=true
    me.cpucounter=@_cpucounter
    me.zero      =@_zeroasm
    me.zerobuffer=@_zerobuffer
    me.copy      =@_copyasm
    me.mix16     =@_mixasm16
    me.scale16   =@_scaleasm16

    me.panleft16 =@_panleftasm16
    me.panright16=@_panrightasm16

    me.copyright16 =@_copyrightasm16
    me.copyright32 =@_copyrightasm32
    me.moveright16 =@_moverightasm16
    me.moveright32 =@_moverightasm32

    me.copysliceright16 =@_copyslicerightasm16
    me.copysliceright32 =@_copyslicerightasm32
    me.movesliceright16 =@_moveslicerightasm16
    me.movesliceright32 =@_moveslicerightasm32

    me.copysliceleft16 =@_copysliceleftasm16
    me.copysliceleft32 =@_copysliceleftasm32
    me.movesliceleft16 =@_movesliceleftasm16
    me.movesliceleft32 =@_movesliceleftasm32
  end if

#ifndef NOMP3

  me.CopyMP3Frame        =@_CopyMP3FrameASM
  ' copy frame and convert playback rate to stereo output
  me.CopySliceMP3Frame32 =@_CopySliceMP3FrameASM32
  ' copy frame and convert playback rate to mono output
  me.CopySliceMP3Frame16 =@_CopySliceMP3FrameASM16
  ' scale stereo frame to 16bit stereo output
  me.ScaleMP3Frame_22_16 =@_ScaleMP3Frame_22_asm16
  ' scale stereo frame to 16bit mono output
  me.ScaleMP3Frame_21_16 =@_ScaleMP3Frame_21_asm16
  ' scale mono frame to 16bit stereo output
  me.ScaleMP3Frame_12_16 =@_ScaleMP3Frame_12_asm16
  ' scale mono frame to 16bit mono output
  me.ScaleMP3Frame_11_16 =@_ScaleMP3Frame_11_asm16
#endif

end sub

sub fbscpu_exit() destructor
  dprint("cpu:~")
end sub

private function _cpucounter() as longint
  return me.mhz*timer()*1000000.0
end function 

function IsFPU()  as boolean 
  return me.fpu
end function 
function IsTSC()  as boolean 
  return me.tsc
end function 
function IsCMOV() as boolean 
  return me.cmov
end function 
function IsMMX()  as boolean 
  return me.mmx
end function 
function IsMMX2() as boolean 
  return me.mmx
end function 
function IsSSE()  as boolean 
  return me.sse
end function 
function IsSSE2() as boolean 
  return me.sse2
end function 
function Is3DNOW() as boolean 
  return me.n3d
end function 
function Is3DNOW2() as boolean 
  return me.n3d2
end function 

function MHz() as long 
  return me.mhz
end function 

function CpuCounter() as longint 
  return me.cpucounter()
end function 

sub Zero(byval d as any ptr, _
         byval n as integer) 
  if (n>1) and (d<>0) then me.zero(d,n):exit sub
  dprint("cpu:zero wrong param!")
end sub

sub ZeroBuffer(byval s as any ptr , _
               byval p as any ptr ptr, _
               byval e as any ptr , _
               byval n as integer  ) 
  if (n>0) and (s<>0) then me.zerobuffer(s,p,e,n):exit sub
  dprint("cpu: ZeroBuffer wrong param!")
end sub

sub Copy(byval d as any ptr, _
         byval s as any ptr, _
         byval n as integer ) 
  if (n>1) and (d<>0) and (s<>0) then me.copy(d,s,n):exit sub
  dprint("cpu: Copy wrong param!")
end sub

sub Mix16(d as any ptr, _
          a as any ptr, _
          b as any ptr, _
          n as integer ) 
  if (n>1) andalso (d<>0) andalso (a<>0) andalso (b<>0) andalso ((n and 1)=0) then me.Mix16(d,a,b,n):exit sub
  dprint("cpu: Mix16 wrong param!")
end sub

sub Scale16(byval d as any ptr, _
            byval s as any ptr, _
            byval v as single , _
            byval n as integer ) 
  if (n>1) andalso (d<>0) andalso (s<>0) andalso ((n and 1)=0) then me.scale16(d,s,v,n):exit sub
  dprint("cpu: Scale16 wrong param!")
end sub 

sub Pan16 (byval d as any ptr, _
           byval s as any ptr, _
           byval l as single , _
           byval r as single , _
           byval n as integer ) 
  if (n>0) andalso (d<>0) andalso (s<>0) andalso ((n and 1)=0)  andalso ((l=1) or (r=1))  then 
    if (l=1) then 
      me.panright16(d,s,r,n):exit sub
    else
      me.panleft16(d,s,l,n):exit sub  
    end if
  end if  
  dprint("cpu: Pan16 wrong param!")
end sub

sub CopyRight16(byval d as any ptr , _
                byval s as any ptr , _
                byval p as any ptr ptr, _
                byval e as any ptr , _
                byval l as integer ptr, _
                n as integer  ) 
 if (n>0) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (s<>e) andalso (l<>0) andalso ((n and 1)=0) then me.copyright16(d,s,p,e,l,n) : exit sub
 dprint("cpu: CoveRight16 wrong param!")
end sub

sub CopyRight32(byval d as any ptr , _
                byval s as any ptr , _
                byval p as any ptr ptr, _
                byval e as any ptr , _
                byval l as integer ptr, _
                byval n as integer  ) 
 if (n>0) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) then me.copyright32(d,s,p,e,l,n) : exit sub
 dprint("cpu: CoveRight32 wrong param!")
end sub

sub MoveRight16(byval s as any ptr , _
                byval p as any ptr ptr, _
                byval e as any ptr , _
                byval l as integer ptr, _
                byval n as integer  ) 
 if (n>1) andalso (s<>0) andalso (p<>0) andalso (e<>0)  andalso (l<>0) andalso ((n and 1)=0) then me.moveright16(s,p,e,l,n):exit sub
 dprint("cpu: MoveRight16 wrong param!")
end sub

sub MoveRight32(byval s as any ptr , _
                byval p as any ptr ptr, _
                byval e as any ptr , _
                byval l as integer ptr, _
                byval n as integer) 
 if (n>1) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) then me.moveright32(s,p,e,l,n):exit sub
 dprint("cpu: MoveRight32 wrong param!" & str(n))
end sub

sub CopySliceRight16(byval d as any ptr , _
                     byval s as any ptr , _
                     byval p as any ptr ptr, _
                     byval e as any ptr , _
                     byval l as integer ptr, _
                     byval v as single  , _
                     byval n as integer  ) 
  if (n>1) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 1)=0) andalso (v>0.0) then me.copysliceright16(d,s,p,e,l,v,n):exit sub
  dprint("cpu: CopySliceRight16 wrong param!")
end sub

sub CopySliceRight32(byval d as any ptr , _
                     byval s as any ptr , _
                     byval p as any ptr ptr, _
                     byval e as any ptr , _
                     byval l as integer ptr, _
                     byval v as single  , _
                     byval n as integer  ) 
  if (n>3) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) andalso (v>0.0) then me.copysliceright32(d,s,p,e,l,v,n):exit sub
  dprint("cpu: CopySliceRight32 wrong param!")
end sub

sub CopySliceLeft16(byval d as any ptr , _
                    byval s as any ptr , _
                    byval p as any ptr ptr, _
                    byval e as any ptr , _
                    byval l as integer ptr, _
                    byval v as single  , _
                    byval n as integer) 
  if (n>1) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 1)=0) andalso (v<0.0) then me.copysliceleft16(d,s,p,e,l,v,n):exit sub
  dprint("cpu: CopySliceLeft16 wrong param!")
end sub

' copy and slice stereo samples left to stereo
sub CopySliceLeft32(byval d as any ptr , _
                    byval s as any ptr , _
                    byval p as any ptr ptr, _
                    byval e as any ptr , _
                    byval l as integer ptr, _
                    byval v as single  , _
                    byval n as integer) 
  if (n>3) andalso (d<>0) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) and (v<0.0) then me.copysliceleft32(d,s,p,e,l,v,n):exit sub
  dprint("cpu: CopySliceLeft32 wrong param!")
end sub

' move and slice stereo samples right to mono
sub MoveSliceRight16(byval s as any ptr , _
                     byval p as any ptr ptr, _
                     byval e as any ptr , _
                     byval l as integer ptr, _
                     byval v as single  , _
                     byval n as integer) 
  if (n>1) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 1)=0) andalso (v>0.0) then me.movesliceright16(s,p,e,l,v,n):exit sub
  dprint("cpu: MoveSliceRight16 wrong param!")
end sub
' move and slice stereo samples right to stereo
sub MoveSliceRight32(byval s as any ptr , _
                     byval p as any ptr ptr, _
                     byval e as any ptr , _
                     byval l as integer ptr, _
                     byval v as single  , _
                     byval n as integer  ) 
  if (n>3) andalso (s<>0) andalso (p<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) andalso (v>0.0) then me.movesliceright32(s,p,e,l,v,n):exit sub
  dprint("cpu: MoveSliceRight32 wrong param!")
end sub
' move and slice stereo samples left to mono
sub MoveSliceLeft16(byval s as any ptr , _
                    byval p as any ptr ptr, _
                    byval e as any ptr , _
                    byval l as integer ptr, _
                    byval v as single  , _
                    byval n as integer  ) 
  if (n>1) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 1)=0) andalso (v<0.0) then me.movesliceleft16(s,p,e,l,v,n):exit sub
  dprint("cpu: MoveSliceLeft16 wrong param!")
end sub

' move and slice stereo samples left to stereo
sub MoveSliceLeft32(byval s as any ptr , _
                    byval p as any ptr ptr, _
                    byval e as any ptr , _
                    byval l as integer ptr, _
                    byval v as single  , _
                    byval n as integer  ) 
  if (n>3) andalso (s<>0) andalso (p<>0) andalso (e<>0) andalso (l<>0) andalso ((n and 3)=0) andalso (v<0.0) then me.movesliceleft32(s,p,e,l,v,n):exit sub
  dprint("cpu: MoveSliceLeft32 wrong param!")
end sub

#ifndef NOMP3

' copy MP3 frame with same samerate as output device
sub CopyMP3Frame(byval s as any ptr , _
                 byval p as any ptr ptr, _
                 byval e as any ptr , _
                 byval f as any ptr , _ 
                 byval n as integer  ) 
  me.CopyMP3Frame(s,p,e,f,n)
end sub

' stereo output
sub CopySliceMP3Frame32(byval s as any ptr , _
                        byval p as any ptr ptr, _
                        byval e as any ptr , _
                        byval f as any ptr , _
                        byval v as single  , _ 
                        byval n as integer  ) 
  me.CopySliceMP3Frame32(s,p,e,f,v,n)
end sub
' mono output
sub CopySliceMP3Frame16(byval s as any ptr , _
                        byval p as any ptr ptr, _
                        byval e as any ptr , _
                        byval f as any ptr , _
                        byval v as single  , _ 
                        byval n as integer  ) 
  me.CopySliceMP3Frame16(s,p,e,f,v,n)
end sub

' scale stereo frame to stereo output 
sub ScaleMP3Frame_22_16(byval d  as any ptr , _
                        byval s1 as any ptr , _
                        byval s2 as any ptr , _
                        byval n  as integer  ) 
  me.ScaleMP3Frame_22_16(d,s1,s2,n)
end sub

' scale stereo frame to mono output
sub ScaleMP3Frame_21_16(byval d  as any ptr , _
                        byval s1 as any ptr , _
                        byval s2 as any ptr , _
                        byval n  as integer  ) 
  me.ScaleMP3Frame_21_16(d,s1,s2,n)
end sub

' scale mono frame to stereo output
sub ScaleMP3Frame_12_16(byval d  as any ptr , _
                        byval s1 as any ptr , _
                        byval n  as integer  ) 
  me.ScaleMP3Frame_12_16(d,s1,n)
end sub

' scale mono frame to mono output
sub ScaleMP3Frame_11_16(byval d  as any ptr , _
                        byval s1 as any ptr , _
                        byval n  as integer  ) 
  me.ScaleMP3Frame_11_16(d,s1,n)
end sub
#endif
