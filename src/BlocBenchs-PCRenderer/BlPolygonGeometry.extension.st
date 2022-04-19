Extension { #name : #BlPolygonGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolygonGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	aPCCanvas setClosedPathGeometry: self with: [ :cairoContext |
		self vertices do: [ :each | cairoContext lineTo: each ].
		cairoContext primClosePath ]
]
