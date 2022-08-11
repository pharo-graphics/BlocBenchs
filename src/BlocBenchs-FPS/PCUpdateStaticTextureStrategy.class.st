Class {
	#name : #PCUpdateStaticTextureStrategy,
	#superclass : #PCSDLTextureStrategy,
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCUpdateStaticTextureStrategy >> drawDone [

	sdlTexture
		updateTexturePixels: sdlSurface pixels
		pitch: sdlSurface pitch.

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
		format: AeCairoSurfaceFormat CAIRO_FORMAT_ARGB32.

	cairoContext := aCairoSurface newContext.

	setupBlock value: cairoContext
]

{ #category : #drawing }
PCUpdateStaticTextureStrategy >> sdlTextureAccess [

	^ SDL_TEXTUREACCESS_STATIC
]