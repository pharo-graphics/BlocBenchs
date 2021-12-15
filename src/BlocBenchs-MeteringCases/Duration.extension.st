Extension { #name : #Duration }

{ #category : #'*BlocBenchs-MeteringCases' }
Duration class >> microSeconds: aNumber [
	"A microsecond is equal to 1000 nanoseconds."

	^ self nanoSeconds: aNumber * 1e3
]
