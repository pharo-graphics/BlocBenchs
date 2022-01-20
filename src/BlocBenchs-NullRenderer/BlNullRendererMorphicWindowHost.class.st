"
I'm a hacky way to set the NullRenderer ini a MorphicWindow host.
"
Class {
	#name : #BlNullRendererMorphicWindowHost,
	#superclass : #BlMorphicWindowHost,
	#category : #'BlocBenchs-NullRenderer'
}

{ #category : #'driver selection' }
BlNullRendererMorphicWindowHost class >> label [
	^ 'Morphic NullRenderer'
]

{ #category : #'host - api' }
BlNullRendererMorphicWindowHost >> createHostSpaceFor: aSpace [
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
