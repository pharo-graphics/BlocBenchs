Extension { #name : #BlCircleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlCircleGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	aPCCanvas setClosedPathGeometry: self with: [ :cairoContext |
		cairoContext
			primArcCenterX: self origin x + self radius
			centerY: self origin y + self radius
			radius: self radius
			startAngle: 0.0
			endAngle: Float twoPi ]

]
