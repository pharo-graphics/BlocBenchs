Class {
	#name : #BlMorphicWindowHostNullRenderer,
	#superclass : #BlMorphicWindowHost,
	#category : #'BlocBenchs-NullRenderer'
}

{ #category : #'driver selection' }
BlMorphicWindowHostNullRenderer class >> label [
	^ 'Morphic NullRenderer'
]

{ #category : #'host - api' }
BlMorphicWindowHostNullRenderer >> createHostSpaceFor: aSpace [
	"Create and assign a new morphic host space for given bloc space"
	| aWindow aHostSpace|

	self
		assert: [ aSpace hasHostSpace not ]
		description: [ 'Space must not have a host!' ].

	aWindow := self createMorphicWindowFor: aSpace.
	aHostSpace := BlMorphicWindowHostSpace new morphicWindow: aWindow.
	aHostSpace host: self.
	aHostSpace universe: self universe.
	aHostSpace space: aSpace.
	aHostSpace withNullRenderer.

	aSpace hostSpace: aHostSpace
]
