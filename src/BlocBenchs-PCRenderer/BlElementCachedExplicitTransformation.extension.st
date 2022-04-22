Extension { #name : #BlElementCachedExplicitTransformation }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElementCachedExplicitTransformation >> pureCairoApplyTo: aPCCanvas element: aBlElement [

	self ensureMatrix.
	aPCCanvas pathTransform:
		(AeCairoMatrix
			 x: matrix x
			 y: matrix y
			 sx: matrix sx
			 sy: matrix sy
			 shx: matrix shx
			 shy: matrix shy)
]
