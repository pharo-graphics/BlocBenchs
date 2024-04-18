Class {
	#name : #SDLShapedWindowExample,
	#superclass : #Object,
	#instVars : [
		'sdlWindow',
		'sdlRenderer',
		'sdlTexture',
		'shapeMode',
		'referencedObjectsUntilTearDown',
		'shapeSurface'
	],
	#pools : [
		'SDL2Constants',
		'SDL2Types'
	],
	#category : #'BlocBenchs-SDL-ShapedWindow'
}

{ #category : #examples }
SDLShapedWindowExample class >> exampleByBinarizedAlpha [

	| example |
	example := self new
		shapeSurface: self newShapeSurface;
		shapeByBinarizedAlpha: 1;
		yourself.
		
	example show.
	
	2 seconds wait.
	
	example tearDown.

]

{ #category : #examples }
SDLShapedWindowExample class >> exampleByColorKey [

	| example |
	example := self new
		shapeSurface: self newShapeSurface;
		shapeByColorKey: Color transparent;
		yourself.
	
	example show.
	
	2 seconds wait.
	
	example tearDown.

]

{ #category : #examples }
SDLShapedWindowExample class >> newShapeSurface [
	
	^ self surfaceWithRoundedCornersExtent: 256 asPoint
	"^ self surfaceFromForm: (self iconNamed: #pharoBig)"
]

{ #category : #examples }
SDLShapedWindowExample class >> surfaceFromForm: aForm [

	| convertedForm aSDLSurface |
	convertedForm := aForm unhibernate; asFormOfDepth: 32.
	aSDLSurface :=
		SDL2
			createRGBSurfaceFromPixels: convertedForm bits
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
SDLShapedWindowExample class >> surfaceWithRoundedCornersExtent: extent [

	| sdlSurface cairoSurface |

	sdlSurface :=
		SDL2
			createRGBSurfaceWithFormat: SDL_PIXELFORMAT_ARGB8888
			depth: 32
			width: extent x
			height: extent y.

	sdlSurface lockSurface.
		
	cairoSurface :=
		AeCairoImageSurface
			newForData: sdlSurface pixels
			extent: extent
			stride: sdlSurface pitch
			format: AeCairoSurfaceFormat argb32.

	cairoSurface newContext
		sourceColor: Color transparent;
		paint;
		sourceColor: Color yellow;
		roundedRectangleTo: extent radius: extent min / 3;
		fill.

	cairoSurface flush.
	
	sdlSurface unlockSurface.

	^ sdlSurface
]

{ #category : #examples }
SDLShapedWindowExample >> initialize [

	super initialize.
	referencedObjectsUntilTearDown := OrderedCollection new.

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
SDLShapedWindowExample >> sdlWindow [

	^ sdlWindow
]

{ #category : #examples }
SDLShapedWindowExample >> shapeByBinarizedAlpha: threshold [

	shapeMode := SDL_WindowShapeMode
		mode: SDL_WindowShapeModeEnum ShapeModeBinarizeAlpha
		parameters: (SDL_WindowShapeParams binarizationCutoff: threshold)
]

{ #category : #examples }
SDLShapedWindowExample >> shapeByColorKey: aColor [

	| aSDLColor aSDLWindowShapeParams |
	aSDLColor := SDL_Color autoReleasingNewFrom: aColor.
	aSDLWindowShapeParams := SDL_WindowShapeParams colorKey: aSDLColor.

	shapeMode := SDL_WindowShapeMode
		mode: SDL_WindowShapeModeEnum ShapeModeColorKey 
		parameters: aSDLWindowShapeParams.

	referencedObjectsUntilTearDown
		add: aSDLColor;
		add: aSDLWindowShapeParams
]

{ #category : #examples }
SDLShapedWindowExample >> shapeSurface: aSDLSurface [

	shapeSurface := aSDLSurface
]

{ #category : #examples }
SDLShapedWindowExample >> show [

"	SDL2 initVideo."

	sdlWindow := SDL2
		createShapedWindow: 'Shaped Window - Color Key'
		x: 50
		y: 50
		width: shapeSurface w
		height: shapeSurface h
		flags: SDL_WINDOW_SHOWN.
	
	100 milliSeconds wait.
	
"	[ 20 milliSeconds wait ] doWhileFalse: [
		';' trace.
		sdlWindow isShaped ].
	'.' traceCr.	
"
	(sdlWindow
		primSetWindowShape: shapeSurface
		mode: shapeMode) in: [ :result |
			result = 0 ifFalse: [
				self error: 'Unsuccessful operation' ] ].

	sdlRenderer := sdlWindow createDefaultRenderer.
	sdlTexture := sdlRenderer primCreateTextureFromSurface: shapeSurface.
	sdlRenderer
		drawColorR: 0 g: 255 b: 255 a: 255; "cyan"
		clear;
		copy: sdlTexture;
		present
]

{ #category : #examples }
SDLShapedWindowExample >> tearDown [

	referencedObjectsUntilTearDown removeAll.
	shapeSurface := nil.
	
	sdlTexture ifNotNil: #destroy.
	sdlTexture := nil.

	sdlRenderer ifNotNil: #destroy.
	sdlRenderer := nil.

	sdlWindow ifNotNil: #destroy.
	sdlWindow := nil.


]
