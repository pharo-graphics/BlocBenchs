Class {
	#name : #PCCompositionEnabledViaCairoWindow,
	#superclass : #PCCompositionWindow,
	#instVars : [
		'layerCairoSurfacePattern'
	],
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCCompositionEnabledViaCairoWindow >> drawOnCairoSurface [

	super drawOnCairoSurface.

	"Figures are cached"
	cairoContext
		sourcePattern: layerCairoSurfacePattern;
		paint

]

{ #category : #drawing }
PCCompositionEnabledViaCairoWindow >> resetAnimation [

	super resetAnimation.

	cairoContext pushGroup.
	self drawFiguresOn: cairoContext.
	layerCairoSurfacePattern := cairoContext popGroupAsSurfacePattern
]
