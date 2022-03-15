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

	aPCCanvas
		position: self position
		transformation: self transformation matrix
		applyDuring: [
			
			self background pureCairoApplyTo: aPCCanvas.
			self outskirts pureCairoApplyTo: aPCCanvas.
			self border pureCairoApplyTo: aPCCanvas.
			self geometry
				pureCairoDraw: self
				on: aPCCanvas.
			
			self childrenDo: [:each |
				each pureCairoDrawOn: aPCCanvas ] ]

]
