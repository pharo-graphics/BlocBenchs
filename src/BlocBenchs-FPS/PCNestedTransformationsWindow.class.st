Class {
	#name : #PCNestedTransformationsWindow,
	#superclass : #PCBenchCaseRawSDLCairoWindow,
	#instVars : [
		'backgroundColors',
		'figureMatrices',
		'rotationPerMS',
		'scalePerMS',
		'rotationCenter',
		'rotationCenterNegated',
		'windowColor'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCNestedTransformationsWindow >> drawOnCairoCanvasFigureAt: index [

	cairoContext setIdentityMatrix.

	"Translate to figure's position"
	cairoContext translateBy: case figureOffset.

	"Apply figure's transformation using the right origin"
	cairoContext
		translateBy: rotationCenter;
		transformWith: (figureMatrices at: index);
		translateBy: rotationCenterNegated.

	"Draw rectangle path"
	cairoContext
		rectangleX: 0.0
			y: 0.0
			width: case figureExtent x
			height: case figureExtent y;
		sourceColor: (backgroundColors at: index);
		fill.
	

]

{ #category : #stepping }
PCNestedTransformationsWindow >> drawOnCairoSurface [

	"Prepare on first draw"
	backgroundColors
		ifNil: [
			windowColor := PCFloatColor newFrom: Color white.
			backgroundColors := (1 to: case numberOfFigures)
				collect: [ :each | PCFloatColor newRandom: random ].
			figureMatrices := (1 to: case numberOfFigures)
				collect: [:each | AeCairoMatrix newIdentity ].
			scalePerMS := case targetRelativeScale / 
				(case numberOfMilliseconds * 10.0). "Why 10x more?"
			rotationPerMS := case targetRelativeRotation degreesToRadians / 
				case numberOfMilliseconds.
			rotationCenter := case figureExtent / 2.0.
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
	1 to: case numberOfFigures do: [ :index |
		self drawOnCairoCanvasFigureAt: index ]

]
