Extension { #name : #BlPolylineGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolylineGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	^ aPCCanvas acceptGeometryPolyline: self element: aBlElement
]
