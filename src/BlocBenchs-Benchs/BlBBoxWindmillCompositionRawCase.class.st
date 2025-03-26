Class {
	#name : #BlBBoxWindmillCompositionRawCase,
	#superclass : #BlBRawCase,
	#traits : 'TBlBBoxWindmillLogic',
	#classTraits : 'TBlBBoxWindmillLogic classTrait',
	#instVars : [
		'pixelBoxExtent',
		'boxPositions',
		'pixelBoxPositions',
		'sdlRects',
		'boxTextureStrategy'
	],
	#category : #'BlocBenchs-Benchs-Raw'
}

{ #category : #drawing }
BlBBoxWindmillCompositionRawCase >> drawBoxOn: aeCairoContext [
	"set path (outskirts = center)"

	aeCairoContext
		rectangleX: self boxBorderWidth / 2
		y: self boxBorderWidth / 2
		width: self boxExtent x
		height: self boxExtent y.

	"draw background"
	aeCairoContext
		sourceColor: self boxColor;
		fillPreserve.

	"draw border"
	aeCairoContext
		sourceColor: self boxBorderColor;
		strokeSize: self boxBorderWidth;
		stroke
]

{ #category : #'drawing - steps' }
BlBBoxWindmillCompositionRawCase >> drawOnCairoSurface [
	"Completely done via composition of SDL textures"
]

{ #category : #'drawing - steps' }
BlBBoxWindmillCompositionRawCase >> presentOnWindow [

	"Background"
	sdlRenderer copy: mainTextureStrategy sdlTexture.

	"Boxes"
	boxPositions withIndexDo: [ :eachPosition :index |
		| errorCode |
		errorCode := sdlRenderer
			copy: boxTextureStrategy sdlTexture
			srcRect: SDL_Rect null
			dstRect: (sdlRects at: index)
			angle: (self
				boxRotationInDegreesWithPosition: eachPosition
				elapsedMS: self elapsedMillisecondsSinceFirstDraw)
			center: SDL_Point null.

		SDL2
			ensureSuccessCode: errorCode
			description: 'Calling SDL_RenderCopyEx' ].

	"Frame is ready to be shown"
	sdlRenderer present
]

{ #category : #'drawing - steps' }
BlBBoxWindmillCompositionRawCase >> setupMainTexture [ 

	mainTextureStrategy := PCUpdateStaticTextureStrategy
		newExtent: sdlRenderer outputExtent
		renderer: sdlRenderer
		setupBlock: setupBlock.

	mainTextureStrategy cairoContextDo: [ :aeCairoContext |
		aeCairoContext
			sourceColor: Color black;
			paint.
		].

	"Adapt positions and extents to screen's scale factor"
	pixelBoxExtent :=
		(self boxExtent x * deviceScalePoint x) @
		(self boxExtent y * deviceScalePoint y).

	boxPositions := self boxPositions.
	pixelBoxPositions := self boxPositions: deviceScalePoint.
	sdlRects := pixelBoxPositions collect: [:each |
		SDL_Rect
			newX: each x
			y: each y
			w: pixelBoxExtent x
			h: pixelBoxExtent y].

	"Render a box in a static texture"
	boxTextureStrategy := PCUpdateStaticTextureStrategy 
		newExtent: pixelBoxExtent + (self boxBorderWidth * deviceScalePoint)
		renderer: sdlRenderer
		setupBlock: setupBlock.
	boxTextureStrategy setBlendEnabled.
	boxTextureStrategy cairoContextDo: [ :aeCairoContext |
		self drawBoxOn: aeCairoContext ]

]
