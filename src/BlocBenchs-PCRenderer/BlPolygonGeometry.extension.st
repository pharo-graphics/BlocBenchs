Extension { #name : #BlPolygonGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolygonGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	^ aPCCanvas acceptGeometryPolygon: self element: aBlElement
]
