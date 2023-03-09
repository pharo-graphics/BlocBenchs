Extension { #name : #'SDL_Window' }

{ #category : #'*BlocBenchs-SDL' }
SDL_Window >> createSoftwareRenderer [
	^ self createRenderer: -1 flags: SDL_RENDERER_SOFTWARE 
]

{ #category : #'*BlocBenchs-SDL' }
SDL_Window >> isShaped [

	^ self ffiCall: #(bool SDL_IsShapedWindow(void))
]

{ #category : #'*BlocBenchs-SDL' }
SDL_Window >> position: aPoint [

	self setPositionX: aPoint x asInteger y: aPoint y asInteger
]

{ #category : #'*BlocBenchs-SDL' }
SDL_Window >> primSetWindowShape: aShape mode: aShapeMode [
	"Set the shape and parameters of a shaped window.
	
	See: https://github.com/libsdl-org/SDL/blob/53dea9830964eee8b5c2a7ee0a65d6e268dc78a1/include/SDL_shape.h#L128
	"
	^ self ffiCall: #( 
		int
		SDL_SetWindowShape(
			self,
			SDL_Surface * aShape,
			SDL_WindowShapeMode * aShapeMode)
		)
]
