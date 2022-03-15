Extension { #name : #BlRectangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlRectangleGeometry >> pureCairoDraw: aBlElement on: aPCCanvas [

	^ aPCCanvas draw: aBlElement rectangle: self
]
