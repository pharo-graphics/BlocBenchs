Extension { #name : #SDL2 }

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
