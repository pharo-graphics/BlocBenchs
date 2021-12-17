Extension { #name : #BlPaintBackground }

{ #category : #'*BlocBenchs-PCRenderer' }
BlPaintBackground >> pureCairoApplyTo: aPCRenderer [

	^ aPCRenderer acceptBlPaintBackground: self
]
