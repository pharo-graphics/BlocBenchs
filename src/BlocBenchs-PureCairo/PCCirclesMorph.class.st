Class {
	#name : #PCCirclesMorph,
	#superclass : #PCTranslatingFiguresMorph,
	#instVars : [
		'circleColors'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCCirclesMorph >> drawOnCairoCanvas [

	self clearCairoCanvas.

	1 to: case numberOfFigures do: [ :index |
		self setPathFor: index.
		self setSourceFor: index.
		self drawPath ]

]

{ #category : #drawing }
PCCirclesMorph >> drawPath [

	self subclassResponsibility
]

{ #category : #drawing }
PCCirclesMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	circleColors := (1 to: case numberOfFigures)
		collect: [ :each | PCFloatColor newRandom: random ].

]

{ #category : #drawing }
PCCirclesMorph >> setPathFor: index [

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
PCCirclesMorph >> setSourceFor: index [

	cairoCanvas primSetSourceRGBColor: (circleColors at: index)
]
