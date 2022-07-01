Class {
	#name : #PCCleanCanvasWindow,
	#superclass : #PCBenchCaseRawSDLCairoWindow,
	#instVars : [
		'canvasClearColor'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCCleanCanvasWindow >> clearCairoSurface [
	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"

	cairoContext
		setSourceRGBColor: canvasClearColor;
		primPaint

]

{ #category : #drawing }
PCCleanCanvasWindow >> drawOnCairoSurface [

	self clearCairoSurface
]

{ #category : #drawing }
PCCleanCanvasWindow >> resetAnimation [

	super resetAnimation.
	canvasClearColor := PCFloatColor newFrom: Color white
]
