Class {
	#name : #BlBAbstractGradientCirclesCase,
	#superclass : #BlBAbstractCircleCase,
	#instVars : [
		'numberOfStops'
	],
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #benchmarking }
BlBAbstractGradientCirclesCase class >> benchMatrix [

	^ super benchMatrix
		forSelector: #numberOfStops addOptions: #(2 10)
]

{ #category : #running }
BlBAbstractGradientCirclesCase class >> isAbstract [ 

	^ self == BlBAbstractGradientCirclesCase
]

{ #category : #accessing }
BlBAbstractGradientCirclesCase >> defaultLabel [

	^ '{1} w/ {2} stops' format: {
		super defaultLabel.
		numberOfStops }
]

{ #category : #hook }
BlBAbstractGradientCirclesCase >> initialize [

	super initialize.
	
	numberOfStops := 3.
]

{ #category : #hook }
BlBAbstractGradientCirclesCase >> newGradient: random [

	^ self subclassResponsibility
]

{ #category : #hook }
BlBAbstractGradientCirclesCase >> newStops: random [

	^ (0.0 to: 1.0 by: 1 / (numberOfStops - 1)) collect: [ :each |
		  each -> (Color random: random) ]
]

{ #category : #accessing }
BlBAbstractGradientCirclesCase >> numberOfStops [

	^ numberOfStops
]

{ #category : #accessing }
BlBAbstractGradientCirclesCase >> numberOfStops: anInteger [

	numberOfStops := anInteger
]

{ #category : #hook }
BlBAbstractGradientCirclesCase >> prepare: anElement with: random [

	anElement background: (self newGradient: random)
]
