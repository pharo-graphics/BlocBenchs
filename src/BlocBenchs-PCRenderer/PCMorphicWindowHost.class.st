Class {
	#name : #PCMorphicWindowHost,
	#superclass : #BlMorphicWindowHost,
	#category : #'BlocBenchs-PCRenderer-Host-MorphicWindow'
}

{ #category : #'driver selection' }
PCMorphicWindowHost class >> label [
	^ 'Morphic PureCairo'
]

{ #category : #'host - api' }
PCMorphicWindowHost >> createHostSpaceFor: aSpace [
	"Create and assign a new morphic host space for given bloc space"

	| aWindow aHostSpace|
	aWindow := self createMorphicWindowFor: aSpace.

	aHostSpace := BlMorphicWindowHostSpace new
		morphicWindow: aWindow;
		host: self;
		universe: self universe;
		space: aSpace;
		renderer: PCRenderer new;
		yourself.

	aSpace hostSpace: aHostSpace
]
