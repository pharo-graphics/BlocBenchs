Extension { #name : #BlImageBackground }

{ #category : #'*BlocBenchs-PCRenderer' }
BlImageBackground >> pureCairoApplyTo: aPCCanvas [ 
	
	^ aPCCanvas acceptBlImageBackground: self
]
