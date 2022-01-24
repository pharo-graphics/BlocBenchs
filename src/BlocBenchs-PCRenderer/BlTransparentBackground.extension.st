Extension { #name : #BlTransparentBackground }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTransparentBackground >> pureCairoApplyTo: aPCRenderer [ 

	^ aPCRenderer acceptBlTransparentBackground: self

]
