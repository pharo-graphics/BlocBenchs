Extension { #name : #BlRectangleGeometry }

{ #category : #'*BlocBenchs-PCRenderer' }
BlRectangleGeometry >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	aPCCanvas setClosedPathGeometry: self with: [ :cairoContext |
		| aRectangle |
		aRectangle := aBlElement boundsInLocal.
		
		cairoContext
			rectangleX: aRectangle left
			y: aRectangle top
			width: aRectangle width
			height: aRectangle height ]

]
