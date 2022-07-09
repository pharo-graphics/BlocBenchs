Class {
	#name : #PCCompositionEnabledViaSDLWindow,
	#superclass : #PCCompositionWindow,
	#instVars : [
		'layerSdlTexture',
		'layerSdlRectangle',
		'layerSdlSurface'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCCompositionEnabledViaSDLWindow >> presentOnWindow [

	sdlRenderer
		copy: mainTexture sdlTexture;
		copy: layerSdlTexture
			srcRect: layerSdlRectangle
			dstRect: layerSdlRectangle;
		present
]

{ #category : #drawing }
PCCompositionEnabledViaSDLWindow >> resetAnimation [

	super resetAnimation.

"	sdlRenderer drawBlendMode: SDL_BLENDMODE_BLEND."

	self resetLayer.

]

{ #category : #drawing }
PCCompositionEnabledViaSDLWindow >> resetLayer [

	| pixelExtent aCairoSurface aCairoContext |

	"SDL2 set up"	

	pixelExtent := (case layerExtent * deviceScalePoint) asIntegerPoint.
	layerSdlSurface := SDL2
		createRGBSurfaceForCairoWidth: pixelExtent x
		height: pixelExtent y.

	layerSdlTexture := sdlRenderer
		createTextureFormat: SDL_PIXELFORMAT_XRGB8888
		access: SDL_TEXTUREACCESS_STATIC
		width: pixelExtent x
		height: pixelExtent y.

	layerSdlRectangle := SDL_Rect
		newX: 0
		y: 0
		w: pixelExtent x
		h: pixelExtent y.


	"Cairo set up"
	aCairoSurface := AeCairoImageSurface
		newForData: layerSdlSurface pixels
		extent: pixelExtent
		stride: layerSdlSurface pitch
		format: AeCairoSurfaceFormat CAIRO_FORMAT_ARGB32.
	aCairoContext := aCairoSurface newContext.
	"Apply same HiDPI scale"
	aCairoSurface deviceScale: deviceScalePoint.

	"Cairo surface: Clean and draw figures"
	aCairoContext
		primSetSourceR: 0 g: 0 b: 0 a: 0;
		primPaint.
	self drawFiguresOn: aCairoContext.

	"SDL texture: Finally update it"
	layerSdlTexture
		updateTexturePixels: layerSdlSurface pixels
		pitch: layerSdlSurface pitch.

]
