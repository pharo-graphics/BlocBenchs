Extension { #name : #BlElement }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElement >> pureCairoDrawOn: aPCRenderer [ 

	self background pureCairoApplyTo: aPCRenderer.
	self border pureCairoApplyTo: aPCRenderer.

	self transformation pureCairoApplyBeforeDrawingTo: aPCRenderer.
	
	self geometry pureCairoDraw: self on: aPCRenderer.
	self childrenDo: [:each |
		each pureCairoDrawOn: aPCRenderer ].

	self transformation pureCairoApplyAfterDrawingTo: aPCRenderer.

]
