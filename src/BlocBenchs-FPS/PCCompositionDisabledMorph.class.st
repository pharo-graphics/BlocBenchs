Class {
	#name : #PCCompositionDisabledMorph,
	#superclass : #PCCompositionMorph,
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCCompositionDisabledMorph >> drawOnCairoCanvas [

	super drawOnCairoCanvas.
	
	self drawFigures.
]
