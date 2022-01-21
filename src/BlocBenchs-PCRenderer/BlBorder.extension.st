Extension { #name : #BlBorder }

{ #category : #'*BlocBenchs-PCRenderer' }
BlBorder >> pureCairoApplyTo: aPCRenderer [

	^ paint pureCairoApplyTo: aPCRenderer border: self
]
