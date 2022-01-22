Extension { #name : #BlElement }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElement >> pureCairoDrawOn: aPCRenderer [ 

	self background pureCairoApplyTo: aPCRenderer.
	self border pureCairoApplyTo: aPCRenderer.

	aPCRenderer
		position: self position
		transformation: self transformation matrix
		applyDuring: [
			self geometry
				pureCairoDraw: self
				on: aPCRenderer.
			self childrenDo: [:each |
				each pureCairoDrawOn: aPCRenderer ] ]

]
