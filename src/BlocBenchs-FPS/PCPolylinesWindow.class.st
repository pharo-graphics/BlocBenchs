Class {
	#name : 'PCPolylinesWindow',
	#superclass : 'PCTranslatingPathsWindow',
	#category : 'BlocBenchs-FPS-Raw',
	#package : 'BlocBenchs-FPS',
	#tag : 'Raw'
}

{ #category : 'drawing' }
PCPolylinesWindow >> drawPath [

	cairoContext stroke
]

{ #category : 'drawing' }
PCPolylinesWindow >> resetAnimation [

	super resetAnimation.

	cairoContext lineWidth: case borderWidth

]

{ #category : 'drawing' }
PCPolylinesWindow >> setPathFor: index deltaY: deltaY [

	| offset |
	offset := case figureOffset + (index * case offsetBetweenFigures) + (0 @ deltaY).

	case vertices do: [:aPoint |
		cairoContext lineTo: aPoint + offset ].

]
