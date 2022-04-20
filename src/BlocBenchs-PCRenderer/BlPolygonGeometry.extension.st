Extension { #name : #BlPolygonGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolygonGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	aPCCanvas setPathFor: self isClosed: true with: [ :cairoContext |
		self vertices do: [ :each | cairoContext lineTo: each ].
		cairoContext primClosePath ]
]
