Class {
	#name : #PCPolylinesMorph,
	#superclass : #PCTranslatingPathsMorph,
	#category : #'BlocBenchs-FPS-RawMorph'
}

{ #category : #drawing }
PCPolylinesMorph >> drawPath [

	cairoContext stroke
]

{ #category : #drawing }
PCPolylinesMorph >> prepareFirstDraw [

	super prepareFirstDraw.

	cairoContext primSetLineWidth: case borderWidth

]

{ #category : #drawing }
PCPolylinesMorph >> setPathFor: index deltaY: deltaY [

	| offset |
	offset := case figureOffset + (index * case horizontalSeparation @ deltaY).

	case vertices do: [:aPoint |
		cairoContext lineTo: aPoint + offset ].

]
