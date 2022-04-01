Class {
	#name : #PCCirclesMorph,
	#superclass : #PCTranslatingPathsMorph,
	#category : #'BlocBenchs-FPS'
}

{ #category : #drawing }
PCCirclesMorph >> setPathFor: index deltaY: deltaY [

	| center |
	center := case figureOffset + case radius + (index * case horizontalSeparation @ deltaY).

	cairoCanvas
		primArcCenterX: center x
			centerY: center y
			radius: case radius x
			startAngle: 0.0
			endAngle: Float twoPi.

]
