Class {
	#name : #PCCompositionEnabledViaCairoWindow,
	#superclass : #PCCompositionWindow,
	#instVars : [
		'layerCairoGroup'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCCompositionEnabledViaCairoWindow >> drawOnCairoSurface [

	super drawOnCairoSurface.

	"Figures are cached in the group"
	cairoContext
		primSetSource: layerCairoGroup;
		primPaint

]

{ #category : #drawing }
PCCompositionEnabledViaCairoWindow >> resetAnimation [

	super resetAnimation.

	cairoContext primPushGroup.
	self drawFiguresOn: cairoContext.
	layerCairoGroup := cairoContext popGroup
]
