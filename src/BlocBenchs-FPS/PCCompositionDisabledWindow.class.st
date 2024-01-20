Class {
	#name : #PCCompositionDisabledWindow,
	#superclass : #PCCompositionWindow,
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCCompositionDisabledWindow >> drawOnCairoSurface [

	super drawOnCairoSurface.
	
	self drawFiguresOn: cairoContext
]
