Class {
	#name : #PCNestedTransformationsMorph,
	#superclass : #PCMorph,
	#instVars : [
		'case',
		'backgroundColors',
		'figureMatrices',
		'rotationPerMS',
		'scalePerMS',
		'rotationCenter',
		'rotationCenterNegated'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCNestedTransformationsMorph >> case [

	^ case
]

{ #category : #accessing }
PCNestedTransformationsMorph >> case: aPCNestedTransformationsBenchCase [

	case := aPCNestedTransformationsBenchCase.
	self surfaceExtent: aPCNestedTransformationsBenchCase surfaceExtent.
	self random: aPCNestedTransformationsBenchCase newRandom.

]

{ #category : #drawing }
PCNestedTransformationsMorph >> drawOnCairoCanvas [

	"Prepare on first draw"
	backgroundColors
		ifNil: [
			backgroundColors := (1 to: case numberOfFigures)
				collect: [ :each | PCFloatColor newRandom: random ].
			figureMatrices := (1 to: case numberOfFigures)
				collect: [:each | AthensCairoMatrix new ].
			scalePerMS := case targetRelativeScale / 
				(case numberOfSeconds * 10000.0). "Why 10x more?"
			rotationPerMS := case targetRelativeRotation degreesToRadians / 
				(case numberOfSeconds * 1000.0).
			rotationCenter := case figureExtent / 2.0.
			rotationCenterNegated := rotationCenter negated.

			"Set white as window background"
			cairoCanvas primSetSourceR: 1.0 g: 1.0 b: 1.0 ]
		ifNotNil: [ 
			figureMatrices withIndexDo: [ :each :index |
				each
					scaleBy: 1.0 - ((deltaMS * scalePerMS) * index);
					rotateByRadians: deltaMS * rotationPerMS * index.
				 ] ].

	"We know source is color white"
	cairoCanvas primPaint.

	"Draw each figure"	
	1 to: case numberOfFigures do: [ :index |
		self drawOnCairoCanvasFigureAt: index ]

]

{ #category : #drawing }
PCNestedTransformationsMorph >> drawOnCairoCanvasFigureAt: index [

	cairoCanvas 	primSaveState.

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
	
	cairoCanvas 	primRestoreState

]
