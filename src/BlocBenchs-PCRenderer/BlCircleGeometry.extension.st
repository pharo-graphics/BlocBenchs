Extension { #name : #BlCircleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlCircleGeometry >> pureCairoDraw: aBlElement on: aPCRenderer [

	aPCRenderer
		drawCircle: origin
		radius: radius asPoint

]
