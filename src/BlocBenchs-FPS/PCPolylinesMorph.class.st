Class {
	#name : #PCPolylinesMorph,
	#superclass : #PCTranslatingPathsMorph,
	#category : #'BlocBenchs-FPS'
}

{ #category : #drawing }
PCPolylinesMorph >> drawPath [

	cairoCanvas stroke
]

{ #category : #drawing }
PCPolylinesMorph >> prepareFirstDraw [

	super prepareFirstDraw.

	cairoCanvas primSetLineWidth: case borderWidth

]

{ #category : #drawing }
PCPolylinesMorph >> setPathFor: index deltaY: deltaY [

	| offset |
	offset := case figureOffset + (index * case horizontalSeparation @ deltaY).

	case vertices do: [:aPoint |
		cairoCanvas lineTo: aPoint + offset ].

]
