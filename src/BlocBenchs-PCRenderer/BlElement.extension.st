Extension { #name : #BlElement }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElement >> pureCairoAsForm [

	| aCanvas |
	self isLayoutRequested
		ifTrue: [ self forceLayout ].

	aCanvas := PCCanvas extent: self extent.
	aCanvas fullDraw: self.
	^ aCanvas asForm

]

{ #category : #'*BlocBenchs-PCRenderer' }
BlElement >> pureCairoDrawOn: aPCCanvas [ 

	self background pureCairoApplyTo: aPCCanvas.
	self border pureCairoApplyTo: aPCCanvas.

	aPCCanvas
		position: self position
		transformation: self transformation matrix
		applyDuring: [
			self geometry
				pureCairoDraw: self
				on: aPCCanvas.
			self childrenDo: [:each |
				each pureCairoDrawOn: aPCCanvas ] ]

]
