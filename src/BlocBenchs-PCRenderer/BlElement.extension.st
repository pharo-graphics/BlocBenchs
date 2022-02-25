Extension { #name : #BlElement }

{ #category : #'*BlocBenchs-PCRenderer' }
BlElement >> pureCairoAsForm [

	| aCanvas |
	aCanvas := PCCanvas new.
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
