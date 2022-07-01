Class {
	#name : #PCCompositionEnabledWindow,
	#superclass : #PCCompositionWindow,
	#instVars : [
		'layerCairoGroup'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCCompositionEnabledWindow >> drawOnCairoSurface [

	super drawOnCairoSurface.

	cairoContext
		primSetSource: layerCairoGroup;
		primPaint.

]

{ #category : #drawing }
PCCompositionEnabledWindow >> newCairoGroupWithFigures [

	cairoContext primPushGroup.

	self drawFigures.

	^ cairoContext popGroup
]

{ #category : #drawing }
PCCompositionEnabledWindow >> resetAnimation [

	super resetAnimation.

	layerCairoGroup := self newCairoGroupWithFigures.
]
