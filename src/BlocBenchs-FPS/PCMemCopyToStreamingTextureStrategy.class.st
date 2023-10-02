Class {
	#name : #PCMemCopyToStreamingTextureStrategy,
	#superclass : #PCSDLTextureStrategy,
	#instVars : [
		'pitchAddress',
		'pixelsAddress'
	],
	#category : 'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCMemCopyToStreamingTextureStrategy >> drawDone [
	"Copy the updated pixels to texture, and unlock."

	SDL2
		memCopy: cairoContext surface data
		to: pixelsAddress
		size: (pitchAddress signedLongAt: 1) * pixelExtent y.

	sdlTexture unlock.

]

{ #category : #drawing }
PCMemCopyToStreamingTextureStrategy >> drawPrepare [

	"Lock texture to get an address and pitch where new pixels will be written"
	sdlTexture lockPixels: pixelsAddress pitch: pitchAddress.

]

{ #category : #drawing }
PCMemCopyToStreamingTextureStrategy >> initialize [

	| aCairoSurface |
	super initialize.

	aCairoSurface := AeCairoImageSurface
		extent: pixelExtent
		format: AeCairoSurfaceFormat argb32.

	cairoContext := aCairoSurface newContext.

	setupBlock value: cairoContext.
	
	pitchAddress := ExternalAddress newPointer.
	pixelsAddress := ExternalAddress newPointer.

]

{ #category : #drawing }
PCMemCopyToStreamingTextureStrategy >> sdlTextureAccess [

	^ SDL_TEXTUREACCESS_STREAMING
]
