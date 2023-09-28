"
I'm a bench case for gradient fills.

My main parameters is ""numberOfStops"".
"
Class {
	#name : 'PCGradientCirclesBenchCase',
	#superclass : 'PCCirclesBenchCase',
	#instVars : [
		'numberOfStops'
	],
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'hook' }
PCGradientCirclesBenchCase >> initialize [

	super initialize.
	
	numberOfStops := 3.
]

{ #category : 'accessing' }
PCGradientCirclesBenchCase >> label [

	^ '{1} w/ {2} stops' format: {
		super label.
		numberOfStops }
]

{ #category : 'hook' }
PCGradientCirclesBenchCase >> newGradient: random [

	^ self subclassResponsibility
]

{ #category : 'hook' }
PCGradientCirclesBenchCase >> newStops: random [

	^ (0.0 to: 1.0 by: (1/(numberOfStops-1)))
		collect: [ :each | each -> (Color random: random) ].

]

{ #category : 'accessing' }
PCGradientCirclesBenchCase >> numberOfStops [

	^ numberOfStops
]

{ #category : 'accessing' }
PCGradientCirclesBenchCase >> numberOfStops: aCollection [
	"Establish the gradient stops, in the form: { 0.0 -> Color black. 1.0 -> Color white }"

	numberOfStops := aCollection
]

{ #category : 'hook' }
PCGradientCirclesBenchCase >> prepare: anElement with: random [

	anElement background: (self newGradient: random)
]
