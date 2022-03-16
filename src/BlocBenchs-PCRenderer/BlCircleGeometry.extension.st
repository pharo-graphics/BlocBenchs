Extension { #name : #BlCircleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlCircleGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	^ aPCCanvas acceptGeometryCircle: self element: aBlElement
]
