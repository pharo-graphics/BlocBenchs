Class {
	#name : #PCPolylinesCachingWindow,
	#superclass : #PCTranslatingPathsWindow,
	#instVars : [
		'path'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCPolylinesCachingWindow >> drawOnCairoSurface [

	| deltaY |
	self clearCairoSurface.
	deltaY := deltaYPerMS * (lastMS - startMS).

	cairoContext
		primSave;
		primTranslateX: 0.0 y: deltaY;
		translate: case figureOffset.
	
	1 to: case numberOfFigures do: [ :index |
		cairoContext
			translate: case offsetBetweenFigures;
			primAppendPath: path;
			setSourceRGBColor: (colors at: index);
			primStroke ].

	cairoContext
		primRestore.

]

{ #category : #drawing }
PCPolylinesCachingWindow >> drawPath [

	cairoContext primStroke
]

{ #category : #drawing }
PCPolylinesCachingWindow >> resetAnimation [

	super resetAnimation.

	self drawPrepare.

		cairoContext primSave.

		case vertices do: [:aPoint |
			cairoContext lineTo: aPoint ].
		
		path := cairoContext copyPath.
		
		cairoContext primRestore.
	
	self drawDone.

]

{ #category : #initialization }
PCPolylinesCachingWindow >> setPathFor: index [

	cairoContext
		primAppendPath: path
]
