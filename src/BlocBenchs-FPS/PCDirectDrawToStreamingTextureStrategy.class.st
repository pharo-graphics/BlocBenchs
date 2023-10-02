Class {
	#name : #PCDirectDrawToStreamingTextureStrategy,
	#superclass : #PCSDLTextureStrategy,
	#instVars : [
		'pitchAddress',
		'pixelsAddress'
	],
	#category : 'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCDirectDrawToStreamingTextureStrategy >> drawDone [

	sdlTexture unlock.
	cairoContext := nil.
]

{ #category : #drawing }
PCDirectDrawToStreamingTextureStrategy >> drawPrepare [

	| aCairoSurface |
	"Lock texture to get an address and pitch where new pixels will be written"
	sdlTexture lockPixels: pixelsAddress pitch: pitchAddress.

	"Create cairo surface and context based on the previous result"
	aCairoSurface := AeCairoImageSurface
		newForData: pixelsAddress
		extent: pixelExtent
		stride: (pitchAddress signedLongAt: 1)
		format: AeCairoSurfaceFormat argb32.

"	This should be true:
	(pitchAddress signedLongAt: 1) = (AeCairoImageSurface 
		primStrideForWidth: pixelExtent x
		format: AeCairoSurfaceFormat argb32).
"

	cairoContext := aCairoSurface newContext.

	setupBlock value: cairoContext
]

{ #category : #drawing }
PCDirectDrawToStreamingTextureStrategy >> initialize [

	super initialize.

	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer.

]

{ #category : #drawing }
PCDirectDrawToStreamingTextureStrategy >> sdlTextureAccess [

	^ SDL_TEXTUREACCESS_STREAMING
]
