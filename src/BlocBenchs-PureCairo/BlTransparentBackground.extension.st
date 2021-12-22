Extension { #name : #BlTransparentBackground }

{ #category : #'*BlocBenchs-PureCairo' }
BlTransparentBackground >> pureCairoApplyTo: aPCRenderer [ 

	^ aPCRenderer acceptBlTransparentBackground: self

]
