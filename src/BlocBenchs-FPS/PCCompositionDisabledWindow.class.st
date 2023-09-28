Class {
	#name : 'PCCompositionDisabledWindow',
	#superclass : 'PCCompositionWindow',
	#category : 'BlocBenchs-FPS-Raw',
	#package : 'BlocBenchs-FPS',
	#tag : 'Raw'
}

{ #category : 'drawing' }
PCCompositionDisabledWindow >> drawOnCairoSurface [

	super drawOnCairoSurface.
	
	self drawFiguresOn: cairoContext
]
