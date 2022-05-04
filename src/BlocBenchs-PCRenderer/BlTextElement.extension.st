Extension { #name : #BlTextElement }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTextElement >> pureCairoDrawOn: aPCCanvas [
	super pureCairoDrawOn: aPCCanvas.

	paragraph containerExtent: self extent.
	paragraph selection: self selection.

	aPCCanvas pathTranslate: self padding topLeft.
	paragraph pureCairoDrawOn: aPCCanvas.
	aPCCanvas pathTranslate: self padding topLeft negated.

]
