Class {
	#name : #PCLayerCompositionOnMorph,
	#superclass : #PCCleanCanvasMorph,
	#instVars : [
		'indexOfElementToRefresh',
		'figurePositions',
		'figureCairoSurface',
		'figureExtent',
		'borderColorGenerator',
		'layer1',
		'layer2',
		'refreshingFigurePosition'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCLayerCompositionOnMorph >> drawOnCairoCanvas [

	super drawOnCairoCanvas.

	cairoContext
		primSetSource: layer1;
		primPaint.

	cairoContext
		primRectangleX: refreshingFigurePosition x
			y: refreshingFigurePosition y
			width: figureExtent x
			height: figureExtent y;
		primSetSourceRGBColor: borderColorGenerator next;
		primSetLineWidth: case borderWidth;
		stroke.

	cairoContext
		primSetSource: layer2;
		primPaint.

]

{ #category : #drawing }
PCLayerCompositionOnMorph >> newGroupForFigures: someFigurePositions [

	cairoContext primPushGroup.

	someFigurePositions doWithIndex: [ :aPoint :index |
		cairoContext
			primSetSourceSurface: figureCairoSurface
				x: aPoint x
				y: aPoint y;
			primRectangleX: aPoint x
				y: aPoint y
				width: figureExtent x
				height: figureExtent y;
			fill ].
	
	^ cairoContext popGroup
]

{ #category : #drawing }
PCLayerCompositionOnMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	figurePositions := (1 to: case numberOfFigures) collect: [ :index |
		case nextLocation: random ].

	figureCairoSurface := PCCairoSurface fromForm: case theForm.
	figureExtent := case theForm extent.

	borderColorGenerator := case newColorGenerator.
	indexOfElementToRefresh := case indexOfElementToRefresh.

	refreshingFigurePosition := figurePositions at: indexOfElementToRefresh.
	
	layer1 := self newGroupForFigures: (figurePositions first: indexOfElementToRefresh).
	layer2 := self newGroupForFigures: (figurePositions last: (case numberOfFigures - indexOfElementToRefresh)).

]
