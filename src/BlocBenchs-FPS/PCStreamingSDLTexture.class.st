Class {
	#name : #PCStreamingSDLTexture,
	#superclass : #PCSDLTexture,
	#instVars : [
		'pitchAddress',
		'pixelsAddress'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCStreamingSDLTexture >> drawDone [

	sdlTexture unlock.
	cairoContext := nil.
]

{ #category : #drawing }
PCStreamingSDLTexture >> drawPrepare [

	| aCairoSurface |
	"Lock texture to get an address and pitch where new pixels will be written"
	sdlTexture lockPixels: pixelsAddress pitch: pitchAddress.

	"Create cairo surface and context based on the previous result"
	aCairoSurface := AeCairoImageSurface
		newForData: pixelsAddress
		extent: pixelExtent
		stride: (pitchAddress signedLongAt: 1)
		format: AeCairoSurfaceFormat CAIRO_FORMAT_ARGB32.

	cairoContext := aCairoSurface newContext.

	setupBlock value: cairoContext
]

{ #category : #drawing }
PCStreamingSDLTexture >> initialize [

	super initialize.

	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer.

]

{ #category : #drawing }
PCStreamingSDLTexture >> sdlTextureAccess [

	^ SDL_TEXTUREACCESS_STREAMING
]