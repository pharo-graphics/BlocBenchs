Class {
	#name : #PCPolylinesMorph2,
	#superclass : #PCTranslatingPathsMorph,
	#instVars : [
		'path'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCPolylinesMorph2 >> drawOnCairoCanvas [

	| deltaY |
	self clearCairoCanvas.
	deltaY := deltaYPerMS * (lastMS - startMS).

	cairoContext
		primSave;
		primTranslateX: 0.0 y: deltaY;
		translate: case figureOffset.
	
	1 to: case numberOfFigures do: [ :index |
		cairoContext
			primTranslateX: case horizontalSeparation y: 0;
			primAppendPath: path;
			setSourceRGBColor: (colors at: index);
			primStroke ].

	cairoContext
		primRestore.

]

{ #category : #drawing }
PCPolylinesMorph2 >> drawPath [

	cairoContext primStroke
]

{ #category : #drawing }
PCPolylinesMorph2 >> prepareFirstDraw [

	super prepareFirstDraw.

	cairoContext primSave.

	case vertices do: [:aPoint |
		cairoContext lineTo: aPoint ].
	
	path := cairoContext copyPath.
	
	cairoContext primRestore.
]

{ #category : #initialization }
PCPolylinesMorph2 >> setPathFor: index [

	cairoContext
		primAppendPath: path
]
