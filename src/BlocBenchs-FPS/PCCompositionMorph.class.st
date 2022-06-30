Class {
	#name : #PCCompositionMorph,
	#superclass : #PCCleanCanvasMorph,
	#instVars : [
		'figurePositions',
		'figureColors',
		'backgroundColorGenerator'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCCompositionMorph >> drawFigures [
	
	1 to: case numberOfFigures do: [ :index |
		| position |
		position := figurePositions at: index.

		cairoContext
			primRectangleX: position x
				y: position y
				width: case figureExtent x
				height: case figureExtent y.
				
		cairoContext
			setSourceRGBColor: (figureColors at: index);
			primFill

		]

]

{ #category : #drawing }
PCCompositionMorph >> drawOnCairoCanvas [

	canvasClearColor := backgroundColorGenerator next.
	self clearCairoCanvas.

]

{ #category : #drawing }
PCCompositionMorph >> prepareFirstDraw [

	super prepareFirstDraw.

	backgroundColorGenerator := case newColorGenerator.
	figureColors := OrderedCollection new.
	figurePositions := OrderedCollection new.

	1 to: case numberOfFigures do: [ :index |
		figureColors add: (Color random: random).
		figurePositions add: (case nextLocation: random) ].

]
