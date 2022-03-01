Class {
	#name : #PCMorphicWindowHost,
	#superclass : #BlMorphicWindowHost,
	#category : #'BlocBenchs-PCRenderer-Core'
}

{ #category : #'driver selection' }
PCMorphicWindowHost class >> label [
	^ 'Morphic PureCairo'
]

{ #category : #'host - api' }
PCMorphicWindowHost >> createHostSpaceFor: aSpace [
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
	aHostSpace withPureCairoRenderer.

	aSpace hostSpace: aHostSpace
]
