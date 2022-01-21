Extension { #name : #BlColorPaint }

{ #category : #'*BlocBenchs-PCRenderer' }
BlColorPaint >> pureCairoApplyTo: aPCRenderer border: aBlBorder [ 
	
	^ aPCRenderer acceptColorPaintBorder: self border: aBlBorder
]
