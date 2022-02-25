Extension { #name : #BlTransparentBackground }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTransparentBackground >> pureCairoApplyTo: aPCCanvas [ 

	^ aPCCanvas acceptBlTransparentBackground: self

]
