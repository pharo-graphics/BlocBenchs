Extension { #name : #BlMorphicWindowHostSpace }

{ #category : #'*BlocBenchs-NullRenderer' }
BlMorphicWindowHostSpace >> withNullRenderer [
	
	renderer := BlNullRenderer new
]

{ #category : #'*BlocBenchs-NullRenderer' }
BlMorphicWindowHostSpace >> withPureCairoRenderer [
	
	renderer := PCRenderer new
]
