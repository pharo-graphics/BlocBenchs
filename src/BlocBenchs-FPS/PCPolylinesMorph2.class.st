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
		primSaveState;
		primTranslateX: 0.0 y: deltaY;
		primTranslate: case figureOffset.
	
	1 to: case numberOfFigures do: [ :index |
		cairoContext
			primTranslateX: case horizontalSeparation y: 0;
			primAppendPath: path;
			primSetSourceRGBColor: (colors at: index);
			stroke ].

	cairoContext
		primRestoreState.

]

{ #category : #drawing }
PCPolylinesMorph2 >> drawPath [

	cairoContext stroke
]

{ #category : #drawing }
PCPolylinesMorph2 >> prepareFirstDraw [

	super prepareFirstDraw.

	cairoContext primSaveState.

	case vertices do: [:aPoint |
		cairoContext lineTo: aPoint ].
	
	path := cairoContext primCopyPath initialize.
	
	cairoContext primRestoreState.
]

{ #category : #initialization }
PCPolylinesMorph2 >> setPathFor: index [

	cairoContext
		primAppendPath: path
]
