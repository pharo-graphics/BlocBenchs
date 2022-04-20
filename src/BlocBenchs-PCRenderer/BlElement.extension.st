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

	aPCCanvas drawElementAlpha: self opacity with: [

		"Apply transformations"
		aPCCanvas pathTranslate: self position.
		self transformation pureCairoApplyTo: aPCCanvas element: self.
		
		"PCCanvas requires this order: background, outskirts, border."
		self background pureCairoApplyTo: aPCCanvas.
		self outskirts pureCairoApplyTo: aPCCanvas.
		self border pureCairoApplyTo: aPCCanvas.
		self geometry pureCairoApplyTo: aPCCanvas element: self.
		aPCCanvas drawFillAndStroke.

		"Recursively draw children"
		self children isEmpty ifFalse: [
			aPCCanvas setClipChildren: self clipChildren.
			self children sortedByElevation do: [ :each |
				each pureCairoDrawOn: aPCCanvas ] ].

		]
]
