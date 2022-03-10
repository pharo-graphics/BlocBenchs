Extension { #name : #BlPolygonGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolygonGeometry >> pureCairoDraw: aBlElement on: aPCCanvas [

	^ aPCCanvas draw: aBlElement polygon: self
]
