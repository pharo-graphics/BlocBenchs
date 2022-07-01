Class {
	#name : #PCPolylinesWindow,
	#superclass : #PCTranslatingPathsWindow,
	#category : #'BlocBenchs-FPS-Raw'
}

{ #category : #drawing }
PCPolylinesWindow >> drawPath [

	cairoContext primStroke
]

{ #category : #drawing }
PCPolylinesWindow >> resetAnimation [

	super resetAnimation.

	cairoContext primSetLineWidth: case borderWidth

]

{ #category : #drawing }
PCPolylinesWindow >> setPathFor: index deltaY: deltaY [

	| offset |
	offset := case figureOffset + (index * case horizontalSeparation @ deltaY).

	case vertices do: [:aPoint |
		cairoContext lineTo: aPoint + offset ].

]
