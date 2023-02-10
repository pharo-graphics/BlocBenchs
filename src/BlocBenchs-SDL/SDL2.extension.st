Extension { #name : #SDL2 }

{ #category : #'*BlocBenchs-SDL' }
SDL2 class >> createRGBSurfaceWithFormat: aSDLPixelFormat depth: depth width: width height: height [
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

{ #category : #'*BlocBenchs-SDL' }
SDL2 class >> createShapedWindow: title x: x y: y width: width height: height flags: flags [
	"Create a window that can be shaped with the specified position, dimensions, and flags.

	See: https://github.com/libsdl-org/SDL/blob/53dea9830964eee8b5c2a7ee0a65d6e268dc78a1/include/SDL_shape.h#L69"

	^ self ffiCall: #(
		SDL_Window
		SDL_CreateShapedWindow(
			"const char *" String title,
			uint x,
			uint y,
			uint width,
			uint height,
			Uint32 flags)
		)

]

{ #category : #'*BlocBenchs-SDL' }
SDL2 class >> getHint: aName [

	^ self ffiCall: #(String SDL_GetHint(String aName))
]

{ #category : #'*BlocBenchs-SDL' }
SDL2 class >> memCopy: src to: dest size: n [

	^ self ffiCall: #(
		void * 
		SDL_memcpy (
			void * dest, 
			const void * src,
			size_t n
			) )

]

{ #category : #'*BlocBenchs-SDL' }
SDL2 class >> primGetPerformanceCounter [

	^ self ffiCall: #(
		Uint64 SDL_GetPerformanceCounter() )
]

{ #category : #'*BlocBenchs-SDL' }
SDL2 class >> primGetPerformanceFrequency [

	^ self ffiCall: #(
		Uint64 SDL_GetPerformanceFrequency() )
]

{ #category : #'*BlocBenchs-SDL' }
SDL2 class >> primGetTicks [

	^ self ffiCall: #(
		Uint32 SDL_GetTicks() )
]

{ #category : #'*BlocBenchs-SDL' }
SDL2 class >> primGetTicks64 [

	^ self ffiCall: #(
		Uint64 SDL_GetTicks64() )
]
