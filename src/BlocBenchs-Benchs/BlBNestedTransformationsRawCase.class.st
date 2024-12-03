Class {
	#name : #BlBNestedTransformationsRawCase,
	#superclass : #BlBRawCase,
	#traits : 'TBlBNestedTransformationsLogic',
	#classTraits : 'TBlBNestedTransformationsLogic classTrait',
	#instVars : [
		'rotationCenter',
		'figureMatrices',
		'rotationCenterNegated',
		'backgroundColors',
		'windowColor',
		'random',
		'scalePerMS',
		'rotationPerMS'
	],
	#category : #'BlocBenchs-Benchs-Raw'
}

{ #category : #drawing }
BlBNestedTransformationsRawCase >> drawOnCairoCanvasFigureAt: index [

	cairoContext setIdentityMatrix.

	"Translate to figure's position"
	cairoContext translateBy: self figureOffset.

	"Apply figure's transformation using the right origin"
	cairoContext
		translateBy: rotationCenter;
		transformWith: (figureMatrices at: index);
		translateBy: rotationCenterNegated.

	"Draw rectangle path"
	cairoContext
		rectangleX: 0.0
			y: 0.0
			width: self figureExtent x
			height: self figureExtent y;
		sourceColor: (backgroundColors at: index);
		fill.
	

]

{ #category : #stepping }
BlBNestedTransformationsRawCase >> drawOnCairoSurface [

	"Prepare on first draw"
	backgroundColors
		ifNil: [
			windowColor := PCFloatColor newFrom: Color white.
			backgroundColors := (1 to: self numberOfFigures)
				collect: [ :each | PCFloatColor newRandom: random ].
			figureMatrices := (1 to: self numberOfFigures)
				collect: [:each | AeCairoMatrix newIdentity ].
			scalePerMS := self targetRelativeScale / 
				(self numberOfMilliseconds * 10.0). "Why 10x more?"
			rotationPerMS := self targetRelativeRotation degreesToRadians / 
				self numberOfMilliseconds.
			rotationCenter := self figureExtent / 2.0.
			rotationCenterNegated := rotationCenter negated ]
		ifNotNil: [ 
			figureMatrices withIndexDo: [ :each :index |
				each
					scaleBy: (1.0 - ((deltaMS * scalePerMS) * index)) asPoint;
					rotateByRadians: deltaMS * rotationPerMS * index.
				 ] ].

	"Clear surface"
	cairoContext
		sourceColor: windowColor;
		paint.

	"Draw each figure"	
	1 to: self numberOfFigures do: [ :index |
		self drawOnCairoCanvasFigureAt: index ]

]

{ #category : #initialization }
BlBNestedTransformationsRawCase >> initialize [ 
	
	super initialize.
	random := self newRandom 
]
