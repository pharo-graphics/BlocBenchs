Class {
	#name : #PCSDLTexture,
	#superclass : #Object,
	#instVars : [
		'sdlRenderer',
		'sdlTexture',
		'sdlSurface',
		'pixelExtent',
		'setupBlock',
		'cairoContext'
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
		createRGBSurfaceForCairoWidth: aPoint x
		height: aPoint y.

	sdlTexture := sdlRenderer
		createTextureFormat: SDL_PIXELFORMAT_XRGB8888
		access: self sdlTextureAccess
		width: aPoint x
		height: aPoint y.

	self initialize.

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
PCSDLTexture >> setBlend: alphaInteger [ 
	"Prepare to copy another textures on me with the indicated alpha. 
	Alpha is represented as an integer between 0 and 255."

	sdlTexture
		blendMode: SDL_BLENDMODE_BLEND;
		alphaMod: alphaInteger

]

{ #category : #drawing }
PCSDLTexture >> setBlendNone [
	"Prepare to copy another textures on me without blending."

	sdlTexture blendMode: SDL_BLENDMODE_NONE
]
