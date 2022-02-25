Extension { #name : #BlTriangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTriangleGeometry >> pureCairoContainsPoint: aPoint in: aBlElement [

	^ PCContainsPointCalc instance
		  is: aPoint
		  inFillOfVertices: self computeVertices
]

{ #category : #'*BlocBenchs-PCRenderer' }
BlTriangleGeometry >> pureCairoDraw: aBlElement on: aPCCanvas [

	^ aPCCanvas drawTriangle: self computeVertices
]
