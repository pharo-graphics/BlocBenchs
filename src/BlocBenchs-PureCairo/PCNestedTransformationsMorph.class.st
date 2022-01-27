Class {
	#name : #PCNestedTransformationsMorph,
	#superclass : #PCMorph,
	#instVars : [
		'backgroundColors',
		'figureMatrices',
		'rotationPerMS',
		'scalePerMS',
		'rotationCenter',
		'rotationCenterNegated',
		'windowColor'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCNestedTransformationsMorph >> drawOnCairoCanvas [

	"Prepare on first draw"
	backgroundColors
		ifNil: [
			windowColor := PCFloatColor newFrom: Color white.
			backgroundColors := (1 to: case numberOfFigures)
				collect: [ :each | PCFloatColor newRandom: random ].
			figureMatrices := (1 to: case numberOfFigures)
				collect: [:each | AthensCairoMatrix new ].
			scalePerMS := case targetRelativeScale / 
				(case numberOfMilliseconds * 10.0). "Why 10x more?"
			rotationPerMS := case targetRelativeRotation degreesToRadians / 
				case numberOfMilliseconds.
			rotationCenter := case figureExtent / 2.0.
			rotationCenterNegated := rotationCenter negated ]
		ifNotNil: [ 
			figureMatrices withIndexDo: [ :each :index |
				each
					scaleBy: 1.0 - ((deltaMS * scalePerMS) * index);
					rotateByRadians: deltaMS * rotationPerMS * index.
				 ] ].

	"Clear surface"
	cairoCanvas
		primSetSourceRGBColor: windowColor;
		primPaint.

	"Draw each figure"	
	1 to: case numberOfFigures do: [ :index |
		self drawOnCairoCanvasFigureAt: index ]

]

{ #category : #drawing }
PCNestedTransformationsMorph >> drawOnCairoCanvasFigureAt: index [

	cairoCanvas 	primLoadIdentity.

	"Translate to figure's position"
	cairoCanvas primTranslate: case figureOffset.

	"Apply figure's transformation using the right origin"
	cairoCanvas
		primTranslate: rotationCenter;
		primApplyTransform: (figureMatrices at: index);
		primTranslate: rotationCenterNegated.

	"Draw rectangle path"
	cairoCanvas
		primRectangleX: 0.0
			y: 0.0
			width: case figureExtent x
			height: case figureExtent y;
		primSetSourceRGBColor: (backgroundColors at: index);
		fill.
	

]
