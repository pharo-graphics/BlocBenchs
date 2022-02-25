Extension { #name : #BlTransparentPaint }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTransparentPaint >> pureCairoApplyTo: aPCCanvas border: aBlBorder [

	^ aPCCanvas acceptTransparentPaintBorder: aBlBorder
]
