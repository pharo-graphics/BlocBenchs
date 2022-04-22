Trait {
	#name : #AeTCairoDestroy,
	#category : #'BlocBenchs-CairoFFI-Library'
}

{ #category : #finalization }
AeTCairoDestroy classSide >> finalizeResourceData: aHandle [

	aHandle isNull ifTrue: [ ^ self ].
	self primDestroy: aHandle.
	aHandle beNull
]

{ #category : #finalization }
AeTCairoDestroy classSide >> primDestroy: aHandle [
	
	self explicitRequirement
]
