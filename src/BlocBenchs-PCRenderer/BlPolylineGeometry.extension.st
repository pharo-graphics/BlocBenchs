Extension { #name : #BlPolylineGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolylineGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	aPCCanvas setOpenPathGeometry: self with: [ :cairoContext |
		self vertices do: [ :each | cairoContext lineTo: each ] ]
]
