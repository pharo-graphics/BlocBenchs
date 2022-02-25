Extension { #name : #BlRectangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlRectangleGeometry >> pureCairoDraw: aBlElement on: aPCCanvas [

	aPCCanvas drawRectangle: aBlElement boundsInLocal
]
