Extension { #name : #BlPolylineGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolylineGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	aPCCanvas setPathFor: self isClosed: false with: [ :cairoContext |
		self vertices do: [ :each | cairoContext lineTo: each ] ]
]
