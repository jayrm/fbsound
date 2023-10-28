#pragma once

#ifdef __FB_WIN32__
	#ifdef __FB_64BIT__
		const FBSOUND_DLL_PATH = "../bin/win64/"
	#else
		const FBSOUND_DLL_PATH  = "../bin/win32/"
	#endif
#else
	const FBSOUND_DLL_PATH  = ""
#endif
