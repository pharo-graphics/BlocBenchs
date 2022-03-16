Extension { #name : #BlTriangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTriangleGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	^ aPCCanvas acceptGeometryTriangle: self element: aBlElement
]

{ #category : #'*BlocBenchs-PCRenderer' }
BlTriangleGeometry >> pureCairoContainsPoint: aPoint in: aBlElement [

	^ PCContainsPointCalc instance
		  is: aPoint
		  inFillOfVertices: self computeVertices
]
