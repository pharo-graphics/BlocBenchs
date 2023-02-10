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
	#category : #'BlocBenchs-SDL-ShapedWindow'
}

{ #category : #examples }
SDLShapedWindowExample class >> bigPharoSurface [
		
	^ self surfaceFromForm: (self iconNamed: #pharoBig)
]

{ #category : #examples }
SDLShapedWindowExample class >> example [

	| example |
	example := self basicNew
		initializeWithSDLSurface: self sdlSurfaceWithWhiteBackground;
		setUpWithColorKey: Color white;
		yourself.
		
"	example inspect."
	
	example show.
	
	2 seconds wait.
	
	example tearDown.

]

{ #category : #examples }
SDLShapedWindowExample class >> sdlSurfaceWithWhiteBackground [

	| radius extent sdlSurface cairoSurface |
	radius := 128.
	extent := (radius * 2) asPoint.

	sdlSurface := SDL2
		createRGBSurfaceWithFormat: SDL_PIXELFORMAT_ARGB8888
		depth: 32
		width: extent x
		height: extent y.

	sdlSurface lockSurface.
		
	cairoSurface := AeCairoImageSurface
		newForData: sdlSurface pixels
		extent: extent
		stride: sdlSurface pitch
		format: AeCairoSurfaceFormat argb32.

	cairoSurface newContext
		sourceColorRGB: Color white;
		paint;
		sourceColorRGB: Color black;
		circleRadius: radius;
		fill.

	cairoSurface flush.
	
	sdlSurface unlockSurface.

	^ sdlSurface
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
SDLShapedWindowExample >> setUpWithColorKey: aColor [

	| aMode aSDLColor aSDLWindowShapeParams |
"	SDL2 initVideo."

	sdlWindow := SDL2
		createShapedWindow: 'Shaped Window - Color Key'
		x: 100
		y: 100
		width: sdlSurface w
		height: sdlSurface h
		flags: 0.

	self assert: sdlWindow isShaped.

	aSDLColor :=
		SDL_Color externalNew
			autoRelease;
			r: (aColor red   * 255) asInteger;
			g: (aColor green * 255) asInteger;
			b: (aColor blue  * 255) asInteger;
			a: (aColor alpha * 255) asInteger;
			yourself.
	aSDLWindowShapeParams := SDL_WindowShapeParams colorKey: aSDLColor.
	aMode :=	SDL_WindowShapeMode
		mode: SDL_WindowShapeModeEnum ShapeModeColorKey 
		parameters: aSDLWindowShapeParams.

	(sdlWindow primSetWindowShape: sdlSurface mode: aMode) in: [ :result |
		result = 0 ifFalse: [ self error: 'Unsuccessful operation' ] ].


	sdlRenderer := sdlWindow createDefaultRenderer.
	sdlTexture := sdlRenderer primCreateTextureFromSurface: sdlSurface.
	sdlRenderer
		drawColorR: 0 g: 255 b: 255 a: 255;
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

	sdlTexture ifNotNil: [
		sdlTexture destroy.
		sdlTexture := nil ].

	sdlRenderer destroy.
	sdlRenderer := nil.

	sdlWindow hide.	
	sdlWindow destroy.
	sdlWindow := nil.

	sdlSurface := nil.

]
