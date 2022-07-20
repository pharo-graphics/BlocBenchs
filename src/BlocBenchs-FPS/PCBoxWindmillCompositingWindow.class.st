Class {
	#name : #PCBoxWindmillCompositingWindow,
	#superclass : #PCBoxWindmillWindow,
	#instVars : [
		'sdlRects',
		'pixelBoxExtent',
		'pixelBoxPositions',
		'boxPositions',
		'boxTexture'
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
			copy: boxTexture sdlTexture
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
	boxTexture := PCStaticSDLTexture 
		newExtent: pixelBoxExtent + (case boxBorderWidth * deviceScalePoint)
		renderer: sdlRenderer
		setupBlock: self textureSetupBlock.
	boxTexture setBlendEnabled.
	boxTexture cairoContextDo: [ :aeCairoContext |
		self drawBoxOn: aeCairoContext ]

]

{ #category : #initialization }
PCBoxWindmillCompositingWindow >> resetMainTexture [

	mainTexture := PCStaticSDLTexture
		newExtent: sdlRenderer outputExtent
		renderer: sdlRenderer
		setupBlock: self textureSetupBlock.

	mainTexture cairoContextDo: [ :aeCairoContext |
		aeCairoContext
			setSourceRGBAColor: Color black;
			primPaint.
		].
	
	self resetAnimation.
]
