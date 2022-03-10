Class {
	#name : #PCTranslatingPathsMorph,
	#superclass : #PCTranslatingFiguresMorph,
	#instVars : [
		'colors'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingPathsMorph >> drawOnCairoCanvas [

	| deltaY |
	self clearCairoCanvas.
	deltaY := deltaYPerMS * (lastMS - startMS).

	1 to: case numberOfFigures do: [ :index |
		self setPathFor: index deltaY: deltaY.
		self setSourceFor: index.
		self drawPath ]

]

{ #category : #drawing }
PCTranslatingPathsMorph >> drawPath [

	self subclassResponsibility
]

{ #category : #drawing }
PCTranslatingPathsMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	colors := (1 to: case numberOfFigures)
		collect: [ :each | PCFloatColor newRandom: random ].

]

{ #category : #drawing }
PCTranslatingPathsMorph >> setPathFor: index deltaY: deltaY [

	self subclassResponsibility
]

{ #category : #drawing }
PCTranslatingPathsMorph >> setSourceFor: index [

	cairoCanvas primSetSourceRGBColor: (colors at: index)
]
