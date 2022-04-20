Extension { #name : #BlElementCachedExplicitTransformation }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElementCachedExplicitTransformation >> pureCairoApplyTo: aPCCanvas element: aBlElement [ 

	aPCCanvas pathTransform: (PCCairoMatrix fromSpartaMatrix: self matrix)

]
