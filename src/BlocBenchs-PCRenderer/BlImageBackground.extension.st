Extension { #name : #BlImageBackground }

{ #category : #'*BlocBenchs-PCRenderer' }
BlImageBackground >> pureCairoApplyTo: aPCRenderer [ 
	
	^ aPCRenderer acceptBlImageBackground: self
]
