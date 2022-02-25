Extension { #name : #BlCircleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlCircleGeometry >> pureCairoDraw: aBlElement on: aPCCanvas [

	aPCCanvas
		drawCircle: origin
		radius: radius asPoint

]
