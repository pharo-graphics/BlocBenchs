Extension { #name : #BlCircleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlCircleGeometry >> pureCairoDraw: aBlElement on: aPCRenderer [

	aPCRenderer
		drawCircle: aBlElement positionInSpace
		radius: radius asPoint

]
