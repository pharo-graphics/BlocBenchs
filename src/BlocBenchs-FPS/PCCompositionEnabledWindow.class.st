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
		primPaint

]

{ #category : #drawing }
PCCompositionEnabledWindow >> resetAnimation [

	super resetAnimation.

	cairoContext primPushGroup.
	self drawFiguresOn: cairoContext.
	layerCairoGroup := cairoContext popGroup
]
