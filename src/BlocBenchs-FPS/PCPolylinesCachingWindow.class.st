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
		saveState;
		translateByX: 0.0 y: deltaY;
		translateBy: case figureOffset.
	
	1 to: case numberOfFigures do: [ :index |
		cairoContext
			translateBy: case offsetBetweenFigures;
			appendPath: path;
			sourceColor: (colors at: index);
			stroke ].

	cairoContext
		restoreState.

]

{ #category : #drawing }
PCPolylinesCachingWindow >> drawPath [

	cairoContext stroke
]

{ #category : #drawing }
PCPolylinesCachingWindow >> resetAnimation [

	super resetAnimation.

	self drawPrepare.

		cairoContext saveState.

		case vertices do: [:aPoint |
			cairoContext lineTo: aPoint ].
		
		path := cairoContext currentPath.
		
		cairoContext restoreState.
	
	self drawDone.

]

{ #category : #initialization }
PCPolylinesCachingWindow >> setPathFor: index [

	cairoContext
		appendPath: path
]
