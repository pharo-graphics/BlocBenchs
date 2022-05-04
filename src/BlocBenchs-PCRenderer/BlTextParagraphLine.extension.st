Extension { #name : #BlTextParagraphLine }

{ #category : #'*BlocBenchs-PCRenderer' }
BlTextParagraphLine >> pureCairoDrawOn: aPCCanvas [

	self spans do: [ :aSpan | aSpan pureCairoDrawOn: aPCCanvas ]
]
