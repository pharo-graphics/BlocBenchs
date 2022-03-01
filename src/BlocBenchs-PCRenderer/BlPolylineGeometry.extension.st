Extension { #name : #BlPolylineGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPolylineGeometry >> pureCairoDraw: aBlElement on: aPCCanvas [

	^ aPCCanvas drawPolyline: vertices
]
