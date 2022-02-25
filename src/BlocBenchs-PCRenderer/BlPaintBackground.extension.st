Extension { #name : #BlPaintBackground }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPaintBackground >> pureCairoApplyTo: aPCCanvas [

	^ aPCCanvas acceptBlPaintBackground: self
]
