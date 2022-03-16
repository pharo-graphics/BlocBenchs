Extension { #name : #BlRectangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlRectangleGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	^ aPCCanvas acceptGeometryRectangle: self element: aBlElement
]
