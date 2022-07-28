Class {
	#name : #PCSDLTexture,
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
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #'instance creation' }
PCSDLTexture class >> newExtent: aPoint renderer: aSdlRenderer setupBlock: aUnaryBlock [

	^ self basicNew
		  initializeExtent: aPoint renderer: aSdlRenderer setupBlock: aUnaryBlock;
		  yourself
]

{ #category : #accessing }
PCSDLTexture >> cairoContext [

	^ cairoContext
]

{ #category : #accessing }
PCSDLTexture >> cairoContextDo: aBlockClosure [

	self drawPrepare.	
	aBlockClosure value: cairoContext.
	self drawDone.

]

{ #category : #drawing }
PCSDLTexture >> drawDone [
	"Send after using the cairo context"
	
	self subclassResponsibility
]

{ #category : #drawing }
PCSDLTexture >> drawPrepare [
	"Send before using the cairo context"
	
	self subclassResponsibility
]

{ #category : #drawing }
PCSDLTexture >> initializeExtent: aPoint renderer: aSdlRenderer setupBlock: aUnaryBlock [

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
PCSDLTexture >> sdlPixelFormat [

	^ SDL_PIXELFORMAT_ARGB8888
]

{ #category : #accessing }
PCSDLTexture >> sdlRect [

	^ sdlRect 
]

{ #category : #accessing }
PCSDLTexture >> sdlTexture [

	^ sdlTexture 
]

{ #category : #drawing }
PCSDLTexture >> sdlTextureAccess [

	^ self subclassResponsibility
]

{ #category : #drawing }
PCSDLTexture >> setBlendEnabled [

	sdlTexture blendMode: SDL_BLENDMODE_BLEND
]

{ #category : #drawing }
PCSDLTexture >> setBlendNone [
	"Prepare to copy another textures on me without blending."

	sdlTexture blendMode: SDL_BLENDMODE_NONE
]
