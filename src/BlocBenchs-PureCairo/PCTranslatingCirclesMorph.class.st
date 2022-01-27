Class {
	#name : #PCTranslatingCirclesMorph,
	#superclass : #PCTranslatingFiguresMorph,
	#instVars : [
		'backgroundColors'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #drawing }
PCTranslatingCirclesMorph >> prepareFirstDraw [

	super prepareFirstDraw.
	backgroundColors := (1 to: case numberOfFigures)
		collect: [ :each | PCFloatColor newRandom: random ].

]

{ #category : #drawing }
PCTranslatingCirclesMorph >> setBackgroundPathAt: index [

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
PCTranslatingCirclesMorph >> setBackgroundSourceAt: index [

	cairoCanvas primSetSourceRGBColor: (backgroundColors at: index)
]
