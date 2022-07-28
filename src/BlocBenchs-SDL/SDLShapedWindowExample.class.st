Class {
	#name : #SDLShapedWindowExample,
	#superclass : #Object,
	#instVars : [
		'sdlWindow',
		'sdlRenderer',
		'sdlSurface',
		'sdlTexture'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'BlocBenchs-SDL'
}

{ #category : #examples }
SDLShapedWindowExample class >> bigPharoSurface [
		
	^ self surfaceFromForm: (self iconNamed: #pharoBig)
]

{ #category : #examples }
SDLShapedWindowExample class >> example1 [

	self basicNew
		initializeWithSDLSurface: self bigPharoSurface;
		setUpWithBinarizeAlpha;
		show;
		inspect
]

{ #category : #examples }
SDLShapedWindowExample class >> surfaceFromForm: aForm [

	| convertedForm aSDLSurface |
	convertedForm := aForm unhibernate; asFormOfDepth: 32.
	aSDLSurface := SDL2 createRGBSurfaceFromPixels: convertedForm bits
			width: convertedForm width height: convertedForm height
			depth: 32 pitch: convertedForm width * 4
			rmask: 16r00ff0000 
			gmask: 16r000ff00
			bmask: 16r00000ff
			amask: 16rff000000.
	aSDLSurface autoRelease.
	^ aSDLSurface
	

]

{ #category : #examples }
SDLShapedWindowExample >> initializeWithSDLSurface: aSDLSurface [
	"Set the surface that defines the shape of the window.
	Note: We don't take responsability of freeing the surface."

	self initialize.
	sdlSurface := aSDLSurface
]

{ #category : #examples }
SDLShapedWindowExample >> release [

	super release.

	sdlRenderer ifNotNil: [ self tearDown ]
]

{ #category : #examples }
SDLShapedWindowExample >> sdlRenderer [

	^ sdlRenderer
]

{ #category : #examples }
SDLShapedWindowExample >> sdlSurface [

	^ sdlSurface
]

{ #category : #examples }
SDLShapedWindowExample >> sdlWindow [

	^ sdlWindow
]

{ #category : #examples }
SDLShapedWindowExample >> setUpWithBinarizeAlpha [

	| aMode |
	SDL2 initVideo.

	sdlWindow := SDL2
		createShapedWindow: 'Shaped Window - BinarizeAlpha'
		x: SDL_WINDOWPOS_UNDEFINED
		y: SDL_WINDOWPOS_UNDEFINED
		width: sdlSurface w
		height: sdlSurface h
		flags: 0.
		
	aMode :=	SDL_WindowShapeMode
		mode: SDL_WindowShapeModeEnum ShapeModeBinarizeAlpha
		parameters: (SDL_WindowShapeParams binarizationCutoff: 100).

	(sdlWindow primSetWindowShape: sdlSurface mode: aMode) in: [ :result |
		result = 0 ifFalse: [ self error: 'Unsuccessful operation' ] ].

	sdlRenderer := sdlWindow createDefaultRenderer.
	sdlTexture := sdlRenderer primCreateTextureFromSurface: sdlSurface.
	sdlRenderer
"		drawColorR: 0 g: 0 b: 0 a: 0;"
		drawColorR: 200 g: 200 b: 200 a: 200;
		clear;
		copy: sdlTexture;
		present

]

{ #category : #examples }
SDLShapedWindowExample >> setUpWithColorKey [

	| aMode |
	SDL2 initVideo.

	sdlWindow := SDL2
		createShapedWindow: 'Shaped Window - Color Key'
		x: SDL_WINDOWPOS_UNDEFINED
		y: SDL_WINDOWPOS_UNDEFINED
		width: sdlSurface w
		height: sdlSurface h
		flags: 0.
		
	aMode :=	SDL_WindowShapeMode
		mode: SDL_WindowShapeModeEnum ShapeModeColorKey 
		parameters: (SDL_WindowShapeParams colorKey: (SDL_Color newFrom: Color transparent)).

	(sdlWindow primSetWindowShape: sdlSurface mode: aMode) in: [ :result |
		result = 0 ifFalse: [ self error: 'Unsuccessful operation' ] ].

	sdlRenderer := sdlWindow createDefaultRenderer.
	sdlTexture := sdlRenderer primCreateTextureFromSurface: sdlSurface.
	sdlRenderer
"		drawColorR: 0 g: 0 b: 0 a: 0;"
		drawColorR: 200 g: 200 b: 200 a: 200;
		clear;
		copy: sdlTexture;
		present

]

{ #category : #examples }
SDLShapedWindowExample >> show [

	sdlWindow show
]

{ #category : #examples }
SDLShapedWindowExample >> tearDown [

	sdlTexture destroy.
	sdlTexture := nil.

	sdlRenderer destroy.
	sdlRenderer := nil.

	sdlWindow hide.	
	sdlWindow destroy.
	sdlWindow := nil.

	sdlSurface := nil.

]
