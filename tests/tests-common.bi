#pragma once

const TESTS_DATA_PATH = "../data/"

#if not defined( FBSOUND_USE_DYNAMIC ) and not defined( FBSOUND_USE_STATIC ) 
'#define FBSOUND_USE_DYNAMIC
#define FBSOUND_USE_STATIC
#endif

'' set the DLL path before including fbsound_dynamic.bi to override
#if defined( FBSOUND_USE_DYNAMIC )
	#ifdef __FB_WIN32__
		#ifdef __FB_64BIT__
			const FBSOUND_DLL_PATH = "../bin/win64/"
		#else
			const FBSOUND_DLL_PATH  = "../bin/win32/"
		#endif
	#else
		const FBSOUND_DLL_PATH  = ""
	#endif
#else
	const FBSOUND_DLL_PATH  = ""
#endif

#if defined( FBSOUND_USE_DYNAMIC )
#include "fbsound/fbsound_dynamic.bi"
#endif

#if defined( FBSOUND_USE_STATIC )

#ifdef __FB_WIN32__
 #ifndef __FB_64BIT__
  #libpath "./lib/win32/"
 #else
  #libpath "./lib/win64/"
 #endif 
#else
 #ifdef  __FB_LINUX__
   #ifndef __FB_64BIT__
    #libpath "./lib/lin32/"
   #else
    #libpath "./lib/lin64/"
   #endif
 #else
   #error 666: Build target must be Windows or Linux !
 #endif
#endif

#include "fbsound/fbsound.bi"

#endif  
