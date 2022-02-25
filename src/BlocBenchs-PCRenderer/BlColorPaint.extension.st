Extension { #name : #BlColorPaint }

{ #category : #'*BlocBenchs-PCRenderer' }
BlColorPaint >> pureCairoApplyTo: aPCCanvas border: aBlBorder [ 
	
	^ aPCCanvas acceptColorPaintBorder: self border: aBlBorder
]
