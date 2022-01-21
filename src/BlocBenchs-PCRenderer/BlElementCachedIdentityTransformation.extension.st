Extension { #name : #BlElementCachedIdentityTransformation }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElementCachedIdentityTransformation >> pureCairoApplyAfterDrawingTo: aPCRenderer [ 
	
	^ aPCRenderer acceptBlElementCachedIdentityTransformationAfter: self
]

{ #category : #'*BlocBenchs-PCRenderer' }
BlElementCachedIdentityTransformation >> pureCairoApplyBeforeDrawingTo: aPCRenderer [ 

	^ aPCRenderer acceptBlElementCachedIdentityTransformationBefore: self

]
