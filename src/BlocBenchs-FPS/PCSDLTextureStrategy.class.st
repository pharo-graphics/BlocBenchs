Class {
	#name : #PCSDLTextureStrategy,
	#superclass : #Object,
	#instVars : [
		'sdlRenderer',
		'sdlTexture',
		'sdlSurface',
		'pixelExtent',
		'setupBlock',
		'cairoContext',
		'sdlRect'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : 'BlocBenchs-FPS-Raw'
}

{ #category : #'instance creation' }
PCSDLTextureStrategy class >> newExtent: aPoint renderer: aSdlRenderer setupBlock: aUnaryBlock [

	^ self basicNew
		  initializeExtent: aPoint renderer: aSdlRenderer setupBlock: aUnaryBlock;
		  yourself
]

{ #category : #accessing }
PCSDLTextureStrategy >> cairoContext [

	^ cairoContext
]

{ #category : #accessing }
PCSDLTextureStrategy >> cairoContextDo: aBlockClosure [

	self drawPrepare.	
	aBlockClosure value: cairoContext.
	self drawDone.

]

{ #category : #drawing }
PCSDLTextureStrategy >> drawDone [
	"Send after using the cairo context"
	
	self subclassResponsibility
]

{ #category : #drawing }
PCSDLTextureStrategy >> drawPrepare [
	"Send before using the cairo context"
	
	self subclassResponsibility
]

{ #category : #drawing }
PCSDLTextureStrategy >> initializeExtent: aPoint renderer: aSdlRenderer setupBlock: aUnaryBlock [

	pixelExtent := aPoint.
	setupBlock := aUnaryBlock.
	sdlRenderer := aSdlRenderer.

	sdlSurface := SDL2
		createRGBSurfaceWithFormat: self sdlPixelFormat
		depth: 32
		width: aPoint x
		height: aPoint y.

	sdlTexture := sdlRenderer
		createTextureFormat: self sdlPixelFormat
		access: self sdlTextureAccess
		width: aPoint x
		height: aPoint y.

	sdlRect := SDL_Rect
		newX: 0
		y: 0
		w: pixelExtent x
		h: pixelExtent y.

	self initialize.

]

{ #category : #drawing }
PCSDLTextureStrategy >> sdlPixelFormat [

	^ SDL_PIXELFORMAT_ARGB8888
]

{ #category : #accessing }
PCSDLTextureStrategy >> sdlRect [

	^ sdlRect 
]

{ #category : #accessing }
PCSDLTextureStrategy >> sdlTexture [

	^ sdlTexture 
]

{ #category : #drawing }
PCSDLTextureStrategy >> sdlTextureAccess [

	^ self subclassResponsibility
]

{ #category : #drawing }
PCSDLTextureStrategy >> setBlendEnabled [

	sdlTexture blendMode: SDL_BLENDMODE_BLEND
]

{ #category : #drawing }
PCSDLTextureStrategy >> setBlendNone [
	"Prepare to copy another textures on me without blending."

	sdlTexture blendMode: SDL_BLENDMODE_NONE
]
