Extension { #name : #BlElementCachedExplicitTransformation }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElementCachedExplicitTransformation >> pureCairoApplyAfterDrawingTo: aPCRenderer [ 

	^ aPCRenderer acceptBlElementCachedExplicitTransformationAfter: self
]

{ #category : #'*BlocBenchs-PCRenderer' }
BlElementCachedExplicitTransformation >> pureCairoApplyBeforeDrawingTo: aPCRenderer [ 
	
	^ aPCRenderer acceptBlElementCachedExplicitTransformationBefore: self
]
