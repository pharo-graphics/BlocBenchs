"
I'm a hacky way to set the NullRenderer in a MorphicWindow host.
"
Class {
	#name : #BlNullRendererMorphicWindowHost,
	#superclass : #BlMorphicWindowHost,
	#category : #'BlocBenchs-FPS-Host-NullRenderer'
}

{ #category : #'driver selection' }
BlNullRendererMorphicWindowHost class >> label [
	^ 'Morphic NullRenderer'
]

{ #category : #'driver selection' }
BlNullRendererMorphicWindowHost class >> priority [
	"Answer lowest value"

	^ Float infinity
]

{ #category : #'host - api' }
BlNullRendererMorphicWindowHost >> createHostSpaceFor: aSpace [
	"Create and assign a new morphic host space for given bloc space"

	| aWindow aHostSpace |
	aWindow := self createMorphicWindowFor: aSpace.

	aHostSpace := BlMorphicWindowHostSpace new
		morphicWindow: aWindow;
		host: self;
		universe: self universe;
		space: aSpace;
		renderer: BlNullRenderer new;
		yourself.

	aSpace hostSpace: aHostSpace
]
