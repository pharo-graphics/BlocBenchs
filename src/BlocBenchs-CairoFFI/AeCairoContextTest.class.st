Class {
	#name : #AeCairoContextTest,
	#superclass : #TestCase,
	#instVars : [
		'surface',
		'context'
	],
	#category : #'BlocBenchs-CairoFFI-Tests'
}

{ #category : #tests }
AeCairoContextTest >> testCreate [

	surface := AeCairoImageSurface extent: 100 @ 50.
	context := AeCairoContext create: surface.

	self deny: context isNil
]
