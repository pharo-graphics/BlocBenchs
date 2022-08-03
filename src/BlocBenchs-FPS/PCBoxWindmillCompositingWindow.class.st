Class {
	#name : #PCBoxWindmillCompositingWindow,
	#superclass : #PCBoxWindmillWindow,
	#instVars : [
		'sdlRects',
		'pixelBoxExtent',
		'pixelBoxPositions',
		'boxPositions',
		'boxTextureStrategy'
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
	sdlRenderer copy: mainTextureStrategy sdlTexture.

	"Boxes"
	boxPositions withIndexDo: [ :eachPosition :index |
		(sdlRenderer
			copy: boxTextureStrategy sdlTexture
			srcRect: SDL_Rect null
			dstRect: (sdlRects at: index)
			angle: (case boxRotationInDegreesWithPosition: eachPosition elapsedMS: frameCount)
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
	boxTextureStrategy := PCUpdateStaticTextureStrategy 
		newExtent: pixelBoxExtent + (case boxBorderWidth * deviceScalePoint)
		renderer: sdlRenderer
		setupBlock: self textureStrategySetupBlock.
	boxTextureStrategy setBlendEnabled.
	boxTextureStrategy cairoContextDo: [ :aeCairoContext |
		self drawBoxOn: aeCairoContext ]

]

{ #category : #initialization }
PCBoxWindmillCompositingWindow >> resetMainTexture [

	mainTextureStrategy := PCUpdateStaticTextureStrategy
		newExtent: sdlRenderer outputExtent
		renderer: sdlRenderer
		setupBlock: self textureStrategySetupBlock.

	mainTextureStrategy cairoContextDo: [ :aeCairoContext |
		aeCairoContext
			setSourceRGBAColor: Color black;
			primPaint.
		].
	
	self resetAnimation.
]
