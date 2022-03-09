Class {
	#name : #PCCirclesMoph,
	#superclass : #PCTranslatingFiguresMorph,
	#instVars : [
		'circleColors'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCCirclesMoph >> drawOnCairoCanvas [

	self clearCairoCanvas.

	1 to: case numberOfFigures do: [ :index |
		self setPathFor: index.
		self setSourceFor: index.
		self drawPath ]

]

{ #category : #drawing }
PCCirclesMoph >> drawPath [

	self subclassResponsibility
]

{ #category : #drawing }
PCCirclesMoph >> prepareFirstDraw [

	super prepareFirstDraw.
	circleColors := (1 to: case numberOfFigures)
		collect: [ :each | PCFloatColor newRandom: random ].

]

{ #category : #drawing }
PCCirclesMoph >> setPathFor: index [

	| center deltaY |
	deltaY := deltaYPerMS * (lastMS - startMS).
	center := case figureOffset + case radius + (index * case horizontalSeparation @ deltaY).

	cairoCanvas
		primArcCenterX: center x
			centerY: center y
			radius: case radius x
			startAngle: 0.0
			endAngle: Float twoPi.

]

{ #category : #drawing }
PCCirclesMoph >> setSourceFor: index [

	cairoCanvas primSetSourceRGBColor: (circleColors at: index)
]
