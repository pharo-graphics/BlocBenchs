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

	cairoContext primLoadIdentity.

	"Translate to figure's position"
	cairoContext translate: case figureOffset.

	"Apply figure's transformation using the right origin"
	cairoContext
		translate: rotationCenter;
		primApplyTransform: (figureMatrices at: index);
		translate: rotationCenterNegated.

	"Draw rectangle path"
	cairoContext
		primRectangleX: 0.0
			y: 0.0
			width: case figureExtent x
			height: case figureExtent y;
		setSourceRGBColor: (backgroundColors at: index);
		primFill.
	

]

{ #category : #drawing }
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
		setSourceRGBColor: windowColor;
		primPaint.

	"Draw each figure"	
	1 to: case numberOfFigures do: [ :index |
		self drawOnCairoCanvasFigureAt: index ]

]
