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

{ #category : #initialization }
PCBenchCase >> initialize [

	super initialize.
	
	numberOfSeconds := 5.

]

{ #category : #hook }
PCBenchCase >> label [

	^ self subclassResponsibility
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

{ #category : #'instance creation' }
PCBenchCase >> newRandom [

	^ Random seed: 1
]

{ #category : #accessing }
PCBenchCase >> numberOfSeconds [

	^ numberOfSeconds
]

{ #category : #accessing }
PCBenchCase >> numberOfSeconds: anObject [

	numberOfSeconds := anObject
]

{ #category : #hook }
PCBenchCase >> surfaceExtent [

	^ 800 @ 500
]
