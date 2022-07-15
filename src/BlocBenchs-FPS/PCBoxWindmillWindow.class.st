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

	"set path (outskirts = center)"
	aeCairoContext
		primRectangleX: case boxBorderWidth / 2
			y: case boxBorderWidth / 2
			width: case boxExtent x
			height: case boxExtent y.
			
	"draw background"
	aeCairoContext
		setSourceRGBAColor: case boxColor;
		primFillPreserve.

	"draw border"
	aeCairoContext
		setSourceRGBAColor: case boxBorderColor;
		primSetLineWidth: case boxBorderWidth;
		primStroke.

]
