"
See RSAnimationExamples>>#example01BoxWindmill
"
Class {
	#name : #PCBoxWindmillWindow,
	#superclass : #PCCleanCanvasWindow,
	#instVars : [
		'figurePositions',
		'figureColors',
		'backgroundColorGenerator'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCBoxWindmillWindow >> drawBoxOn: aeCairoContext [

	"set path"
	aeCairoContext
		primRectangleX: case boxBorderWidth
			y: case boxBorderWidth
			width: case boxExtent x
			height: case boxExtent y.
			
	"draw background"
	aeCairoContext
		setSourceRGBAColor: case boxColor;
		primFillPreserve.

	"draw border"
	aeCairoContext
		setSourceRGBAColor: case boxBorderColor;
		primSetLineWidth: 1;
		primStroke.

]
