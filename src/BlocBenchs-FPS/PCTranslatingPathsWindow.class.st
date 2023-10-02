Class {
	#name : #PCTranslatingPathsWindow,
	#superclass : #PCTranslatingFiguresWindow,
	#instVars : [
		'colors'
	],
	#category : 'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCTranslatingPathsWindow >> drawOnCairoSurface [

	| deltaY |
	super drawOnCairoSurface.
	deltaY := deltaYPerMS * (lastMS - startMS).

	1 to: case numberOfFigures do: [ :index |
		self setPathFor: index deltaY: deltaY.
		self setSourceFor: index.
		self drawPath ]

]

{ #category : #drawing }
PCTranslatingPathsWindow >> drawPath [

	self subclassResponsibility
]

{ #category : #drawing }
PCTranslatingPathsWindow >> resetAnimation [

	super resetAnimation.
	colors := (1 to: case numberOfFigures)
		collect: [ :each | PCFloatColor newRandom: random ].

]

{ #category : #drawing }
PCTranslatingPathsWindow >> setPathFor: index deltaY: deltaY [

	self subclassResponsibility
]

{ #category : #drawing }
PCTranslatingPathsWindow >> setSourceFor: index [

	cairoContext sourceColor: (colors at: index)
]
