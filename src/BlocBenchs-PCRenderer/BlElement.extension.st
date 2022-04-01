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
			
			"Note the canvas assumes this visit order."
			self background pureCairoApplyTo: aPCCanvas.
			self outskirts pureCairoApplyTo: aPCCanvas.
			self border pureCairoApplyTo: aPCCanvas.
			self geometry pureCairoApplyTo: aPCCanvas element: self.

			aPCCanvas withOpacity: self opacity draw: [
				aPCCanvas drawFillAndStroke.

				self clipChildren
					ifTrue: [ aPCCanvas setClipChildrenEnabled ]
					ifFalse: [ aPCCanvas setClipChildrenDisabled ].

				self children sortedByElevation do: [ :each | each pureCairoDrawOn: aPCCanvas ] ] ]
]
