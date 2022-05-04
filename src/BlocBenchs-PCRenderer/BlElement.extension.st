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
BlElement >> pureCairoDrawChildrenOn: aPCCanvas [
	"Draw my children.
	
	Notes:
	- Receiver assumes that position and transformations are already applied on the canvas."
	
	self children isEmpty ifTrue: [ ^self ].

	aPCCanvas setClipChildren: self clipChildren.
	self children sortedByElevation do: [ :each |
		each pureCairoDrawOn: aPCCanvas ].
]

{ #category : #'*BlocBenchs-PCRenderer' }
BlElement >> pureCairoDrawGeometryOn: aPCCanvas [
	"Draw my geometry with the corresponding background and border.

	Notes:
	- PCCanvas requires this 'set up order': background, outskirts, border.
	- Receiver assumes that position and transformations are already applied on the canvas.
	- Sender assumes that position and transformations are maintanined intact."

	self background pureCairoApplyTo: aPCCanvas.
	self outskirts pureCairoApplyTo: aPCCanvas.
	self border pureCairoApplyTo: aPCCanvas.
	self geometry pureCairoApplyTo: aPCCanvas element: self.
	aPCCanvas drawFillAndStroke.

]

{ #category : #'*BlocBenchs-PCRenderer' }
BlElement >> pureCairoDrawOn: aPCCanvas [

	aPCCanvas drawElementAlpha: self opacity with: [

		"Apply transformations"
		aPCCanvas pathTranslate: self position.
		self transformation pureCairoApplyTo: aPCCanvas element: self.

		self pureCairoDrawGeometryOn: aPCCanvas.
		self pureCairoDrawChildrenOn: aPCCanvas.

		]
]
