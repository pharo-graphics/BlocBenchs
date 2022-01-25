"
I define a case to be benchmarked by a PCBenchmarker.

"
Class {
	#name : #PCBenchCase,
	#superclass : #Object,
	#instVars : [
		'numberOfSeconds'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #convenience }
PCBenchCase class >> allBenchCases [

	^ self allSubclasses reject: [ :each | each hasAbstractMethods ]
]

{ #category : #accessing }
PCBenchCase >> duration [

	^ numberOfSeconds seconds
]

{ #category : #initialization }
PCBenchCase >> initialize [

	super initialize.
	
	numberOfSeconds := 5.

]

{ #category : #printing }
PCBenchCase >> label [

	| prefix suffix |
	prefix := 'PC'.
	suffix := 'BenchCase'.

	^ ' ' join: ((self className allButFirst: prefix size) allButLast: suffix size) splitCamelCase
]

{ #category : #hook }
PCBenchCase >> newElement [
	"Answer the Bloc element to be added to the root of the space to setup the benchmark scenario."

	^ self subclassResponsibility
]

{ #category : #hook }
PCBenchCase >> newMorph [
	"Answer the Morphic instance that will be wrapped in a Window to setup the benchmark scenario."

	^ self notYetImplemented
]

{ #category : #private }
PCBenchCase >> newRandom [

	^ Random seed: 1
]

{ #category : #accessing }
PCBenchCase >> numberOfSeconds [

	^ numberOfSeconds
]

{ #category : #accessing }
PCBenchCase >> numberOfSeconds: aNumber [

	numberOfSeconds := aNumber
]

{ #category : #accessing }
PCBenchCase >> surfaceExtent [

	^ self subclassResponsibility
]
