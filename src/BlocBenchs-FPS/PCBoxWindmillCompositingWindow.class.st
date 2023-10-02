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
	#category : 'BlocBenchs-FPS-Raw'
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
		| errorCode |
		errorCode := sdlRenderer
			copy: boxTextureStrategy sdlTexture
			srcRect: SDL_Rect null
			dstRect: (sdlRects at: index)
			angle: (case
				boxRotationInDegreesWithPosition: eachPosition
				elapsedMS: self elapsedMillisecondsSinceFirstDraw)
			center: SDL_Point null.

		SDL2
			ensureSuccessCode: errorCode
			description: 'Calling SDL_RenderCopyEx' ].

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

{ #category : #accessing }
PCBoxWindmillCompositingWindow >> resetMainTexture [

	mainTextureStrategy := PCUpdateStaticTextureStrategy
		newExtent: sdlRenderer outputExtent
		renderer: sdlRenderer
		setupBlock: self textureStrategySetupBlock.

	mainTextureStrategy cairoContextDo: [ :aeCairoContext |
		aeCairoContext
			sourceColor: Color black;
			paint.
		].
	
	self resetAnimation
]
