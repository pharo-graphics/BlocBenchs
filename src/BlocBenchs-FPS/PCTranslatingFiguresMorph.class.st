Class {
	#name : #PCTranslatingFiguresMorph,
	#superclass : #PCCleanCanvasMorph,
	#instVars : [
		'deltaYPerMS'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCTranslatingFiguresMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	deltaYPerMS := case targetTranslation y / case numberOfMilliseconds
]
