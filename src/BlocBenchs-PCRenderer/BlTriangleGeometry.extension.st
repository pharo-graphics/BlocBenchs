Extension { #name : #BlTriangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTriangleGeometry >> pureCairoDraw: aBlElement on: aPCRenderer [

	^ aPCRenderer drawTriangle: self computeVertices
]
