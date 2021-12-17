Extension { #name : #BlRectangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlRectangleGeometry >> pureCairoDraw: aBlElement on: aPCRenderer [

	aPCRenderer drawRectangle: aBlElement boundsInSpace
]
