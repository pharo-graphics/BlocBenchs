"
I define a case to be benchmarked by a PCBenchmarker.

"
Class {
	#name : #PCBenchCase,
	#superclass : #Object,
	#instVars : [
		'numberOfSeconds'
	],
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #convenience }
PCBenchCase class >> allBenchCases [

	^ self allSubclasses
		  reject: [ :each | each hasAbstractMethods ]
		  thenCollect: [ :each | each new ]
]

{ #category : #convenience }
PCBenchCase class >> allBenchCasesWithRaw [

	^ self allBenchCases select: [ :each |
		[ each newRawSDLCairoWindow. true ] onErrorDo: [ false ] ]

]

{ #category : #hook }
PCBenchCase >> angleInDegreesWith: random [
		
	^ random nextInteger: 360
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

{ #category : #accessing }
PCBenchCase >> logicalExtent [

	^ self subclassResponsibility
]

{ #category : #hook }
PCBenchCase >> newColorGenerator [ 

	^ Generator on: [ :generator | 
		| nextIndex wheel|
		nextIndex := 1.
		wheel := Color wheel: 20.
		[ generator yield: (wheel at: nextIndex).
		nextIndex := (nextIndex + 1) \\ wheel size + 1 ] repeat ]
]

{ #category : #hook }
PCBenchCase >> newElement [
	"Answer the Bloc element to be added to the root of the space to setup the benchmark scenario."

	^ self subclassResponsibility
]

{ #category : #private }
PCBenchCase >> newRandom [

	^ Random seed: 1
]

{ #category : #hook }
PCBenchCase >> newRawSDLCairoWindow [
	"Answer a PCBenchCaseRawSDLCairoWindow instance to benchmark this case."

	^ self notYetImplemented
]

{ #category : #accessing }
PCBenchCase >> numberOfMilliseconds [

	^ numberOfSeconds * 1000
]

{ #category : #accessing }
PCBenchCase >> numberOfSeconds [

	^ numberOfSeconds
]

{ #category : #accessing }
PCBenchCase >> numberOfSeconds: aNumber [

	numberOfSeconds := aNumber
]
