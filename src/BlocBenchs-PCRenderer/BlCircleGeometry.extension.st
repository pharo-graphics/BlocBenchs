Extension { #name : #BlCircleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlCircleGeometry >> pureCairoDraw: aBlElement on: aPCCanvas [

	aPCCanvas draw: aBlElement circle: self
]
