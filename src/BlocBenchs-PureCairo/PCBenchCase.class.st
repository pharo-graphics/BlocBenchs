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

	^ self subclassResponsibility
]

{ #category : #hook }
PCBenchCase >> newMorph [

	^ self subclassResponsibility
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
