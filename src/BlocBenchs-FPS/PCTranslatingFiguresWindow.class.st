Class {
	#name : #PCTranslatingFiguresWindow,
	#superclass : #PCCleanCanvasWindow,
	#instVars : [
		'deltaYPerMS'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCTranslatingFiguresWindow >> resetAnimation [

	super resetAnimation.
	deltaYPerMS := case targetTranslation y / case numberOfMilliseconds
]
