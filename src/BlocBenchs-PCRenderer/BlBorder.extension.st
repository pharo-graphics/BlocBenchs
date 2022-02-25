Extension { #name : #BlBorder }

{ #category : #'*BlocBenchs-PCRenderer' }
BlBorder >> pureCairoApplyTo: aPCCanvas [

	^ paint pureCairoApplyTo: aPCCanvas border: self
]
