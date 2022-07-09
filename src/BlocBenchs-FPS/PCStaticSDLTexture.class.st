Class {
	#name : #PCStaticSDLTexture,
	#superclass : #PCSDLTexture,
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCStaticSDLTexture >> drawDone [

	sdlTexture
		updateTexturePixels: sdlSurface pixels
		pitch: sdlSurface pitch.

]

{ #category : #drawing }
PCStaticSDLTexture >> drawPrepare [
	"The cairo context was prepated in initialize."

]

{ #category : #drawing }
PCStaticSDLTexture >> initialize [

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
PCStaticSDLTexture >> sdlTextureAccess [

	^ SDL_TEXTUREACCESS_STATIC
]
