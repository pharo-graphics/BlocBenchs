Class {
	#name : #PCCirclesMorph,
	#superclass : #PCTranslatingPathsMorph,
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCCirclesMorph >> setPathFor: index deltaY: deltaY [

	| center |
	center := case figureOffset + case radius + (index * case horizontalSeparation @ deltaY).

	cairoContext
		primArcCenterX: center x
			centerY: center y
			radius: case radius x
			startAngle: 0.0
			endAngle: Float twoPi.

]
