Extension { #name : #BlPolylineGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolylineGeometry >> pureCairoDraw: aBlElement on: aPCCanvas [

	^ aPCCanvas draw: aBlElement polyline: self
]
