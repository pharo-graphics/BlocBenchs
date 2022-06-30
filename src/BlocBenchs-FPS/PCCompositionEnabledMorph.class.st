Class {
	#name : #PCCompositionEnabledMorph,
	#superclass : #PCCompositionMorph,
	#instVars : [
		'layerCairoGroup'
	],
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCCompositionEnabledMorph >> drawOnCairoCanvas [

	super drawOnCairoCanvas.

	cairoContext
		primSetSource: layerCairoGroup;
		primPaint.

]

{ #category : #drawing }
PCCompositionEnabledMorph >> newCairoGroupWithFigures [

	cairoContext primPushGroup.

	self drawFigures.

	^ cairoContext popGroup
]

{ #category : #drawing }
PCCompositionEnabledMorph >> prepareFirstDraw [

	super prepareFirstDraw.

	layerCairoGroup := self newCairoGroupWithFigures.
]
