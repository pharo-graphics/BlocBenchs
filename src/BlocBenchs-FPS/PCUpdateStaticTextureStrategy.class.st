Class {
	#name : #PCUpdateStaticTextureStrategy,
	#superclass : #PCSDLTextureStrategy,
	#category : 'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCUpdateStaticTextureStrategy >> drawDone [

	sdlTexture
		updateTextureRect: SDL_Rect null
			pixels: sdlSurface pixels
			pitch:  sdlSurface pitch.

]

{ #category : #drawing }
PCUpdateStaticTextureStrategy >> drawPrepare [
	"The cairo context was prepared in initialize."

]

{ #category : #drawing }
PCUpdateStaticTextureStrategy >> initialize [

	| aCairoSurface |
	super initialize.	

	aCairoSurface := AeCairoImageSurface
		newForData: sdlSurface pixels
		extent: pixelExtent
		stride: sdlSurface pitch
		format: AeCairoSurfaceFormat argb32.

	cairoContext := aCairoSurface newContext.

	setupBlock value: cairoContext
]

{ #category : #drawing }
PCUpdateStaticTextureStrategy >> sdlTextureAccess [

	^ SDL_TEXTUREACCESS_STATIC
]
