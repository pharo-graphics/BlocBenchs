Class {
	#name : #PCCompositionWindow,
	#superclass : #PCCleanCanvasWindow,
	#instVars : [
		'figurePositions',
		'figureColors',
		'backgroundColorGenerator'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCCompositionWindow >> drawFigures [
	
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
PCCompositionWindow >> drawOnCairoSurface [

	canvasClearColor := backgroundColorGenerator next.
	super drawOnCairoSurface
]

{ #category : #drawing }
PCCompositionWindow >> resetAnimation [

	super resetAnimation.

	backgroundColorGenerator := case newColorGenerator.
	figureColors := OrderedCollection new.
	figurePositions := OrderedCollection new.

	1 to: case numberOfFigures do: [ :index |
		figureColors add: (PCFloatColor newRandom: random).
		figurePositions add: (case nextLocation: random) ].

]
