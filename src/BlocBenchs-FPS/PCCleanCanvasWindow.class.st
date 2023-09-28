Class {
	#name : 'PCCleanCanvasWindow',
	#superclass : 'PCBenchCaseRawSDLCairoWindow',
	#instVars : [
		'canvasClearColor'
	],
	#category : 'BlocBenchs-FPS-Raw',
	#package : 'BlocBenchs-FPS',
	#tag : 'Raw'
}

{ #category : 'drawing' }
PCCleanCanvasWindow >> clearCairoSurface [
	"Clear background (https://www.cairographics.org/FAQ/#clear_a_surface)"

	cairoContext
		sourceColor: canvasClearColor;
		paint

]

{ #category : 'drawing' }
PCCleanCanvasWindow >> drawOnCairoSurface [

	self clearCairoSurface
]

{ #category : 'drawing' }
PCCleanCanvasWindow >> resetAnimation [

	super resetAnimation.
	canvasClearColor := PCFloatColor newFrom: Color white
]
