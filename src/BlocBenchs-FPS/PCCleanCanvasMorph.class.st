Class {
	#name : #PCCleanCanvasMorph,
	#superclass : #PCMorph,
	#instVars : [
		'canvasClearColor'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCCleanCanvasMorph >> clearCairoCanvas [
	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"

	cairoContext
		primSetSourceRGBColor: canvasClearColor;
		primPaint

]

{ #category : #drawing }
PCCleanCanvasMorph >> drawOnCairoCanvas [

	self clearCairoCanvas
]

{ #category : #drawing }
PCCleanCanvasMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	canvasClearColor := PCFloatColor newFrom: Color white
]
