Class {
	#name : #PCTranslatingFiguresWindow,
	#superclass : #PCCleanCanvasWindow,
	#instVars : [
		'deltaYPerMS'
	],
	#category : 'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCTranslatingFiguresWindow >> resetAnimation [

	super resetAnimation.

	"Convert from Fraction, since Fraction>>* is slow and at the end, cairo expects a Float"
	deltaYPerMS := (case targetTranslation y / case numberOfMilliseconds) asFloat
]
