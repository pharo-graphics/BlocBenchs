Class {
	#name : #AeSDL2Library,
	#superclass : #FFILibrary,
	#pools : [
		'SDL2Constants',
		'SDL2ConstantsHint',
		'SDL2Types'
	],
	#category : #'BlocBenchs-SDL-Core'
}

{ #category : #'error handling' }
AeSDL2Library >> checkForError [

	| msg |
	msg := self getErrorMessage.
	(msg ~= self and: [ msg isNotEmpty ]) ifTrue:[ SDL2Error signal: msg ]
]

{ #category : #native }
AeSDL2Library >> checkLibraryName: aName [
	^ (ExternalAddress loadSymbol: 'SDL_Init' from: aName) notNil
]

{ #category : #clipboard }
AeSDL2Library >> clipboardText [
	| text |
	
	text := self primClipboardText.
	^ text readStringUTF8
]

{ #category : #clipboard }
AeSDL2Library >> clipboardText: text [
	| encoded encoder |
	
	encoded := ByteArray streamContents: [ :stream |
		encoder := ZnUTF8Encoder new.
		encoder 
			next: text size 
			putAll: text asString
			startingAt: 1 
			toStream: stream.
		stream nextPut: 0 ].
	
	encoded pinInMemory.
	self primClipboardText: encoded
]

{ #category : #audio }
AeSDL2Library >> closeAudioDevice: dev [
	^ self ffiCall: #( void SDL_CloseAudioDevice(SDL_AudioDeviceID dev) )
]

{ #category : #video }
AeSDL2Library >> composeCustomBlendMode_srcColorFactor: srcColorFactor dstColorFactor: dstColorFactor colorOperation: colorOperation srcAlphaFactor: srcAlphaFactor dstAlphaFactor: dstAlphaFactor alphaOperation: alphaOperation [
	^ self ffiCall: #(SDL_BlendMode SDL_ComposeCustomBlendMode(SDL_BlendFactor srcColorFactor,
                                                                 SDL_BlendFactor dstColorFactor,
                                                                 SDL_BlendOperation colorOperation,
                                                                 SDL_BlendFactor srcAlphaFactor,
                                                                 SDL_BlendFactor dstAlphaFactor,
                                                                 SDL_BlendOperation alphaOperation))
]

{ #category : #cursor }
AeSDL2Library >> createCursor: data mask: mask w: w h: h hotX: hotX hotY: hotY [
	^ self ffiCall: #( SDL_Cursor SDL_CreateCursor ( Uint8* data, Uint8* mask, int w, int h, int hotX, int hotY ) )
]

{ #category : #cairo }
AeSDL2Library >> createRGBSurfaceForCairoWidth: width height: height [

	^ (self primCreateRGBSurfaceForCairoWidth: width height: height) initialize.
]

{ #category : #video }
AeSDL2Library >> createRGBSurfaceFromPixels: pixels width: width height: height depth: depth pitch: pitch
	rmask: rmask gmask: gmask bmask: bmask amask: amask [
	^ self ffiCall: #( SDL_Surface* SDL_CreateRGBSurfaceFrom 
						( void* pixels , int width , int height , int depth , int pitch ,
						  Uint32 rmask , Uint32 gmask , Uint32 bmask , Uint32 amask ) )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> createRGBSurfaceWithFormat: aSDLPixelFormat depth: depth width: width height: height [
	"See: https://wiki.libsdl.org/SDL_CreateRGBSurfaceWithFormat"

	^ self ffiCall: #(
		SDL_Surface*
		SDL_CreateRGBSurfaceWithFormat (
			0, 
			int width, 
			int height, 
			int depth, 
			Uint32 aSDLPixelFormat) )

]

{ #category : #'as yet unclassified' }
AeSDL2Library >> createShapedWindow: title x: x y: y width: width height: height flags: flags [
	"Create a window that can be shaped with the specified position, dimensions, and flags.

	See: https://github.com/libsdl-org/SDL/blob/53dea9830964eee8b5c2a7ee0a65d6e268dc78a1/include/SDL_shape.h#L69"

	^ self ffiCall: #(
		SDL_Window *
		SDL_CreateShapedWindow(
			"const char *" String title,
			uint x,
			uint y,
			uint width,
			uint height,
			Uint32 flags)
		)

]

{ #category : #cursor }
AeSDL2Library >> createSystemCursor: cursorId [
	^ self ffiCall: #( SDL_Cursor SDL_CreateSystemCursor (SDL_SystemCursorType cursorId) )
]

{ #category : #video }
AeSDL2Library >> createWindow: title x: x y: y width: w height: h flags: flags [
	^ self ffiCall: #( SDL_Window SDL_CreateWindow ( String title, int x, int y, int w, int h, Uint32 flags ) )
]

{ #category : #timer }
AeSDL2Library >> delay: milliseconds [
	^ self ffiCall: #( void SDL_Delay ( Uint32 milliseconds ) )
]

{ #category : #video }
AeSDL2Library >> disableScreenSaver [

	^ self ffiCall: #(void SDL_DisableScreenSaver(void))
]

{ #category : #timer }
AeSDL2Library >> eventType: type state: state [

	^ self ffiCall: #( Uint8 SDL_EventState(Uint32 type, int state))
]

{ #category : #video }
AeSDL2Library >> freeSurface: surface [
	^ self ffiCall: #( void SDL_FreeSurface ( SDL_Surface* surface ) )
]

{ #category : #'game controller' }
AeSDL2Library >> gameControllerNameForIndex: deviceIndex [
	^ self ffiCall: #( SDL_String SDL_GameControllerNameForIndex ( int deviceIndex ) )
]

{ #category : #'game controller' }
AeSDL2Library >> gameControllerOpen: deviceIndex [
	^ self ffiCall: #( SDL_GameController SDL_GameControllerOpen ( int deviceIndex ) )
]

{ #category : #audio }
AeSDL2Library >> getAudioDeviceName: index isCapture: isCapture [
	^ self ffiCall: #( char* SDL_GetAudioDeviceName(int index, int isCapture) ) options: #( optStringEncodingUtf8 ).
]

{ #category : #video }
AeSDL2Library >> getDisplay: displayIndex ddpi: ddpi hdpi: hdpi vdpi: vdpi [
	^ self ffiCall: #( int SDL_GetDisplayDPI(int displayIndex, float* ddpi, float* hdpi, float* vdpi))
]

{ #category : #'error handling' }
AeSDL2Library >> getErrorMessage [
	^ self ffiCall: #( String SDL_GetError ( void ) )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> getHint: aName [

	^ self ffiCall: #(String SDL_GetHint(String aName))
]

{ #category : #audio }
AeSDL2Library >> getNumAudioDevices: isCapture [
	^ self ffiCall: #( int SDL_GetNumAudioDevices(int isCapture) )
]

{ #category : #audio }
AeSDL2Library >> getQueuedAudioSize: dev [
	^ self ffiCall: #( Uint32 SDL_GetQueuedAudioSize(SDL_AudioDeviceID dev) )
]

{ #category : #common }
AeSDL2Library >> getVersion: ver [
	"Get the version of SDL.

	See: https://wiki.libsdl.org/SDL_GetVersion
	"

	^ self ffiCall: #( void SDL_GetVersion(SDL_Version* ver) )
]

{ #category : #opengl }
AeSDL2Library >> glCreateContext: window [
	^ self ffiCall: #( SDL_GLContext SDL_GL_CreateContext ( SDL_Window window ) )
]

{ #category : #opengl }
AeSDL2Library >> glGetAttribute: attr [

	^ ExternalAddress allocate: 4 bytesDuring: [ :value | 
		  self glGetAttribute: attr into: value.
		  value unsignedLongAt: 1 ]
]

{ #category : #opengl }
AeSDL2Library >> glGetAttribute: attr into: value [
	^ self ffiCall: #( int SDL_GL_GetAttribute(SDL_GLattr attr, int *value) )
]

{ #category : #opengl }
AeSDL2Library >> glGetProcAddress: procName [
	^ self ffiCall: #( void* SDL_GL_GetProcAddress ( String procName ) )
]

{ #category : #opengl }
AeSDL2Library >> glMakeCurrent: window context: context [
	^ self ffiCall: #( int SDL_GL_MakeCurrent ( SDL_Window window , SDL_GLContext context ) )
]

{ #category : #opengl }
AeSDL2Library >> glSetAttribute: attr value: value [
	^ self ffiCall: #( int SDL_GL_SetAttribute(SDL_GLattr attr, int value) )
]

{ #category : #opengl }
AeSDL2Library >> glSwapWindow: window [
	^ self ffiCall: #( void SDL_GL_SwapWindow ( SDL_Window window ) )
]

{ #category : #common }
AeSDL2Library >> init: flags [
	^ self ffiCall: #( int SDL_Init ( Uint32 flags ) )
]

{ #category : #common }
AeSDL2Library >> initAudio [
	self initLibrary;
		 initSubSystem: SDL_INIT_AUDIO
]

{ #category : #common }
AeSDL2Library >> initEverything [
	self initLibrary;
		 initSubSystem: SDL_INIT_EVERYTHING
]

{ #category : #common }
AeSDL2Library >> initGameController [
	self initLibrary;
		 initSubSystem: SDL_INIT_GAMECONTROLLER
]

{ #category : #common }
AeSDL2Library >> initJoystick [
	self initLibrary;
		 initSubSystem: SDL_INIT_JOYSTICK
]

{ #category : #common }
AeSDL2Library >> initLibrary [
	"Configure SDL2 in 'application mode', to let the screen to turn off on inactivity.
	 But we let the user to restore 'game mode' on screen, by using #disableScreenSaver"
	
	self initPlatformSpecific.
	
	self
		setHint: SDL_HINT_VIDEO_ALLOW_SCREENSAVER value: '1';
		setHint: SDL_HINT_NO_SIGNAL_HANDLERS value: '1'.
		
	self init: SDL_INIT_NOPARACHUTE.

]

{ #category : #common }
AeSDL2Library >> initPlatformSpecific [

	OSPlatform current sdlPlatform initPlatformSpecific.
]

{ #category : #common }
AeSDL2Library >> initSubSystem: flags [
	^ self ffiCall: #( int SDL_InitSubSystem ( Uint32 flags ) )
]

{ #category : #common }
AeSDL2Library >> initVideo [
	self initLibrary;
		 initSubSystem: SDL_INIT_VIDEO
]

{ #category : #common }
AeSDL2Library >> isAvailable [

	^ [ (ExternalAddress loadSymbol: 'SDL_Init') notNil ]
			onErrorDo: [ false ]
]

{ #category : #'game controller' }
AeSDL2Library >> isGameController: deviceIndex [
	^ self ffiCall: #( bool SDL_IsGameController ( int deviceIndex ) )
]

{ #category : #joystick }
AeSDL2Library >> joystickEventState: state [
	^ self ffiCall: #( SDL_Joystick SDL_JoystickEventState ( int state ) )
]

{ #category : #joystick }
AeSDL2Library >> joystickOpen: deviceIndex [
	^ self ffiCall: #( SDL_Joystick SDL_JoystickOpen ( int deviceIndex ) )
]

{ #category : #'accessing - platform' }
AeSDL2Library >> macModuleName [

	^ 'libSDL2-2.0.0.dylib'
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> memCopy: src to: dest size: n [

	^ self ffiCall: #(
		void * 
		SDL_memcpy (
			void * dest, 
			const void * src,
			size_t n
			) )

]

{ #category : #mouse }
AeSDL2Library >> modState [
	^ self ffiCall: #( SDL_Keymod SDL_GetModState ( ) )
]

{ #category : #mouse }
AeSDL2Library >> mouseState [
	^ self ffiCall: #( Uint32 SDL_GetMouseState ( nil , nil ) )
]

{ #category : #mouse }
AeSDL2Library >> mouseStateX: x y: y [
	^ self ffiCall: #( Uint32 SDL_GetMouseState ( int* x , int* y ) )
]

{ #category : #joystick }
AeSDL2Library >> numberOfJoysticks [
	^ self ffiCall: #( int SDL_NumJoysticks() )
]

{ #category : #audio }
AeSDL2Library >> openAudioDevice: device isCapture: isCapture desired: desired obtained: obtained allowedChanges: allowedChanges [
	^ self ffiCall: #( SDL_AudioDeviceID SDL_OpenAudioDevice(void* device, int isCapture, SDL_AudioSpec* desired, SDL_AudioSpec* obtained, int allowedChanges) )
]

{ #category : #audio }
AeSDL2Library >> pauseAudioDevice: dev pauseOn: pauseOn [
	^ self ffiCall: #( void SDL_PauseAudioDevice(SDL_AudioDeviceID dev, int pauseOn) )
]

{ #category : #event }
AeSDL2Library >> pollEvent: event [
	^ self ffiCall: #( int SDL_PollEvent ( SDL_Event event ) )
]

{ #category : #clipboard }
AeSDL2Library >> primClipboardText [
	^ self ffiCall: #(void* SDL_GetClipboardText ( ) )
]

{ #category : #clipboard }
AeSDL2Library >> primClipboardText: text [
	"It receives a ByteArray because it can be encoded"

	^ self ffiCall: #( int SDL_SetClipboardText ( ByteArray text ) )
]

{ #category : #cairo }
AeSDL2Library >> primCreateRGBSurfaceForCairoWidth: width height: height [
	^ self ffiCall: #( SDL_Surface* SDL_CreateRGBSurface 
						( 0 , int width , int height , 32 ,
						  16r00FF0000 , 16r0000FF00 , 16r000000FF , 0 ) )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> primGetNumRenderDrivers [

	^ self ffiCall: #(
		int SDL_GetNumRenderDrivers ( void ) )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> primGetPerformanceCounter [

	^ self ffiCall: #(
		Uint64 SDL_GetPerformanceCounter() )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> primGetPerformanceFrequency [

	^ self ffiCall: #(
		Uint64 SDL_GetPerformanceFrequency() )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> primGetRenderDriverInfo: info at: index [

	^ self ffiCall: #( 
		int SDL_GetRenderDriverInfo(
			int index,
			SDL_RendererInfo * info) )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> primGetTicks [

	^ self ffiCall: #(
		Uint32 SDL_GetTicks() )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> primGetTicks64 [

	^ self ffiCall: #(
		Uint64 SDL_GetTicks64() )
]

{ #category : #audio }
AeSDL2Library >> queueAudio: dev data: data len: len [
	^ self ffiCall: #( int SDL_QueueAudio(SDL_AudioDeviceID dev, void* data, Uint32 len) )
]

{ #category : #common }
AeSDL2Library >> quit [
	^ self ffiCall: #( void SDL_Quit ( ) )
]

{ #category : #common }
AeSDL2Library >> quitSubSystem: flags [
	^ self ffiCall: #( void SDL_QuitSubSystem ( Uint32 flags ) )
]

{ #category : #'as yet unclassified' }
AeSDL2Library >> renderDriverInfos [
	"Get a collection of `SDL_RendererInfo` objects for the number of 2D rendering drivers available for the current display.

	Inspect:
		SDL2 renderDriverInfos
	"

	^ (0 to: self primGetNumRenderDrivers - 1) collect: [:index |
		| info |
		info := SDL_RendererInfo externalNew autoRelease.
		self primGetRenderDriverInfo: info at: index.
		info ]
]

{ #category : #video }
AeSDL2Library >> setHint: aName value: aValue [
	^ self ffiCall: #(int SDL_SetHint(const char* aName, const char* aValue))
]

{ #category : #mouse }
AeSDL2Library >> setRelativeMouseMode: enabled [
	^ self ffiCall: #( int SDL_SetRelativeMouseMode ( bool enabled ) )
]

{ #category : #cursor }
AeSDL2Library >> showCursor: toggle [
	^ self ffiCall: #( int SDL_ShowCursor ( int toggle ) )
]

{ #category : #timer }
AeSDL2Library >> ticks [
	"Gets the number of milliseconds since the SDL library was initialized"
	^ self ffiCall: #( Uint32 SDL_GetTicks ( ) )
]

{ #category : #'accessing - platform' }
AeSDL2Library >> unixModuleName [

	^ 'libSDL2.so'
]

{ #category : #common }
AeSDL2Library >> version [
	"Answer the SDL version. For example, a SDL_Version(2.0.7)."

	| version |
	version := SDL_Version new.
	self getVersion: version.
	version autoRelease.
	^ version
]

{ #category : #common }
AeSDL2Library >> wasInit: flags [
	^ self ffiCall: #( int SDL_WasInit ( Uint32 flags ) )
]

{ #category : #'accessing - platform' }
AeSDL2Library >> win32ModuleName [

	^ 'SDL2.dll'
]
