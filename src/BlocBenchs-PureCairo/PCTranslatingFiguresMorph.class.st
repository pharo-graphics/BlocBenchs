Class {
	#name : #PCTranslatingFiguresMorph,
	#superclass : #PCMorph,
	#instVars : [
		'deltaYPerMS',
		'canvasClearColor'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingFiguresMorph >> clearCairoCanvas [
	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"

	cairoCanvas
		primSetSourceRGBColor: canvasClearColor;
		primPaint.

]

{ #category : #drawing }
PCTranslatingFiguresMorph >> drawOnCairoCanvas [

	self clearCairoCanvas.

	1 to: case numberOfFigures do: [ :index |
		self setBackgroundPathAt: index.
		self setBackgroundSourceAt: index.

		cairoCanvas fill ]

]

{ #category : #drawing }
PCTranslatingFiguresMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	canvasClearColor := PCFloatColor newFrom: Color white.
	deltaYPerMS := case targetTranslation y / case numberOfMilliseconds
]

{ #category : #drawing }
PCTranslatingFiguresMorph >> setBackgroundPathAt: index [

	self subclassResponsibility
]

{ #category : #drawing }
PCTranslatingFiguresMorph >> setBackgroundSourceAt: index [

	self subclassResponsibility
]
