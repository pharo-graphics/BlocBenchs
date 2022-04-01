Class {
	#name : #PCLayerCompositionOffMorph,
	#superclass : #PCCleanCanvasMorph,
	#instVars : [
		'indexOfElementToRefresh',
		'figurePositions',
		'figureCairoSurface',
		'figureExtent',
		'borderColorGenerator'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCLayerCompositionOffMorph >> drawOnCairoCanvas [

	super drawOnCairoCanvas.

	figurePositions doWithIndex: [ :aPoint :index |

		cairoContext
			primSetSourceSurface: figureCairoSurface
				x: aPoint x
				y: aPoint y;
			primRectangleX: aPoint x
				y: aPoint y
				width: figureExtent x
				height: figureExtent y.
				
		index = indexOfElementToRefresh
			ifFalse: [ cairoContext fill ]
			ifTrue: [
				cairoContext
					fillPreserve;
					primSetSourceRGBColor: borderColorGenerator next;
					primSetLineWidth: case borderWidth;
					stroke ]
		]

]

{ #category : #drawing }
PCLayerCompositionOffMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	figurePositions := (1 to: case numberOfFigures) collect: [ :index |
		case nextLocation: random ].

	figureCairoSurface := PCCairoSurface fromForm: case theForm.
	figureExtent := case theForm extent.

	borderColorGenerator := case newColorGenerator.
	indexOfElementToRefresh := case indexOfElementToRefresh.
]
