Class {
	#name : #PCTranslatingFiguresMorph,
	#superclass : #PCMorph,
	#instVars : [
		'deltaYPerMS',
		'canvasClearColor'
	],
	#category : #'BlocBenchs-FPS'
}

{ #category : #drawing }
PCTranslatingFiguresMorph >> clearCairoCanvas [
	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"

	cairoCanvas
		primSetSourceRGBColor: canvasClearColor;
		primPaint

]

{ #category : #drawing }
PCTranslatingFiguresMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	canvasClearColor := PCFloatColor newFrom: Color white.
	deltaYPerMS := case targetTranslation y / case numberOfMilliseconds
]
