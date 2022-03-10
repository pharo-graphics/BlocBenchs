Class {
	#name : #PCPolylinesMorph2,
	#superclass : #PCTranslatingPathsMorph,
	#instVars : [
		'path'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCPolylinesMorph2 >> drawOnCairoCanvas [

	| deltaY |
	self clearCairoCanvas.
	deltaY := deltaYPerMS * (lastMS - startMS).

	cairoCanvas
		primSaveState;
		primTranslateX: 0.0 y: deltaY;
		primTranslate: case figureOffset.
	
	1 to: case numberOfFigures do: [ :index |
		cairoCanvas
			primTranslateX: case horizontalSeparation y: 0;
			primAppendPath: path;
			primSetSourceRGBColor: (colors at: index);
			stroke ].

	cairoCanvas
		primRestoreState.

]

{ #category : #drawing }
PCPolylinesMorph2 >> drawPath [

	cairoCanvas stroke
]

{ #category : #drawing }
PCPolylinesMorph2 >> prepareFirstDraw [

	super prepareFirstDraw.

	cairoCanvas primSaveState.

	case vertices do: [:aPoint |
		cairoCanvas lineTo: aPoint ].
	
	path := cairoCanvas primCopyPath initialize.
	
	cairoCanvas primRestoreState.
]

{ #category : #initialization }
PCPolylinesMorph2 >> setPathFor: index [

	cairoCanvas
		primAppendPath: path
]
