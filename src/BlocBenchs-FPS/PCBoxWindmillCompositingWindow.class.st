Class {
	#name : #PCBoxWindmillCompositingWindow,
	#superclass : #PCBoxWindmillWindow,
	#instVars : [
		'boxSdlTexture',
		'sdlRects',
		'pixelBoxExtent',
		'pixelBoxPositions',
		'boxPositions'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCBoxWindmillCompositingWindow >> drawOnCairoSurface [
	"Completely done via composition of SDL textures"
]

{ #category : #drawing }
PCBoxWindmillCompositingWindow >> presentOnWindow [

	"Background"
	sdlRenderer copy: mainTexture sdlTexture.

	"Boxes"
	boxPositions withIndexDo: [ :eachPosition :index |
		(sdlRenderer
			copy: boxSdlTexture sdlTexture
			srcRect: SDL_Rect null
			dstRect: (sdlRects at: index)
			angle: (case boxRotationInDegreesWithPosition: eachPosition frame: frameCount)
			center: SDL_Point null) = 0 
				ifFalse: [ self error: SDL2 getErrorMessage ]].

	"Frame is ready to be shown"
	sdlRenderer present
]

{ #category : #drawing }
PCBoxWindmillCompositingWindow >> resetAnimation [

	super resetAnimation.

	"Adapt positions and extents to screen's scale factor"
	pixelBoxExtent :=
		(case boxExtent x * deviceScalePoint x) @
		(case boxExtent y * deviceScalePoint y).

	boxPositions := case boxPositions.
	pixelBoxPositions := case boxPositions: deviceScalePoint.
	sdlRects := pixelBoxPositions collect: [:each |
		SDL_Rect
			newX: each x
			y: each y
			w: pixelBoxExtent x
			h: pixelBoxExtent y].

	"Render a box in a static texture"
	boxSdlTexture := PCStaticSDLTexture 
		newExtent: pixelBoxExtent + ((case boxBorderWidth * 2) * deviceScalePoint)
		renderer: sdlRenderer
		setupBlock: self textureSetupBlock.
	boxSdlTexture drawPrepare.
	self drawBoxOn: boxSdlTexture cairoContext.
	boxSdlTexture drawDone.

]

{ #category : #initialization }
PCBoxWindmillCompositingWindow >> resetMainTexture [

	mainTexture := PCStaticSDLTexture
		newExtent: sdlRenderer outputExtent
		renderer: sdlRenderer
		setupBlock: self textureSetupBlock.
	"Should be black"
		
	self resetAnimation.
]
