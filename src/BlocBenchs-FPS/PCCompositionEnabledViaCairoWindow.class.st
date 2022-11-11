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
		source: layerCairoGroup;
		paint

]

{ #category : #drawing }
PCCompositionEnabledViaCairoWindow >> resetAnimation [

	super resetAnimation.

	cairoContext pushGroup.
	self drawFiguresOn: cairoContext.
	layerCairoGroup := cairoContext popGroup
]
