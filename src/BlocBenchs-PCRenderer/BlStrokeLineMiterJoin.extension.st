Extension { #name : #BlStrokeLineMiterJoin }

{ #category : #'*BlocBenchs-PCRenderer' }
BlStrokeLineMiterJoin >> pureCairoApplyTo: aPCCanvas style: aBorderStyle [

	aPCCanvas setJoinMiter: aBorderStyle miterLimit
]
