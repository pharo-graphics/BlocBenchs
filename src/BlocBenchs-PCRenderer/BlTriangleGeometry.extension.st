Extension { #name : #BlTriangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTriangleGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	aPCCanvas setPathFor: self isClosed: true with: [ :cairoContext |
		| thePoints |
		thePoints := self computeVertices.

		cairoContext
			moveTo: thePoints first;
			lineTo: thePoints second;
			lineTo: thePoints third;
			primClosePath ]

]

{ #category : #'*BlocBenchs-PCRenderer' }
BlTriangleGeometry >> pureCairoContainsPoint: aPoint in: aBlElement [

	^ PCContainsPointCalc instance
		  is: aPoint
		  inFillOfVertices: self computeVertices
]
