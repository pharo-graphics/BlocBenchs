Extension { #name : #BlTransparentPaint }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTransparentPaint >> pureCairoApplyTo: aPCRenderer border: aBlBorder [

	^ aPCRenderer acceptTransparentPaintBorder: aBlBorder
]
