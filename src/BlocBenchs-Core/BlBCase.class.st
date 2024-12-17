Class {
	#name : #BlBCase,
	#superclass : #Object,
	#instVars : [
		'runner',
		'duration',
		'label'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #benchmarking }
BlBCase class >> benchMatrix [
	
	^ ParametrizedTestMatrix new
]

{ #category : #running }
BlBCase class >> benchSuite [

	| benchClasses |
	
	benchClasses := self withAllSubclasses reject: [ :e | e isAbstract ].
	^ benchClasses flatCollect: [ :aClass | aClass possibleBenchCases ]
			
]

{ #category : #running }
BlBCase class >> isAbstract [

	^ self == BlBCase
]

{ #category : #'as yet unclassified' }
BlBCase class >> possibleBenchCases [

	| matrix |

	matrix := self benchMatrix.
	matrix isEmpty ifTrue: [ ^ { self new } ].

	^ matrix expandMatrix collect: [ :aCaseDefinition |
		| aBenchCase |
		aBenchCase := self new.
		aCaseDefinition do: [ :anExpandedParameter |
			anExpandedParameter applyTo: aBenchCase].
		aBenchCase]
]

{ #category : #running }
BlBCase class >> run [
	
	^ self benchSuite collect: [ :e | e run ]

]

{ #category : #'as yet unclassified' }
BlBCase class >> runAllWithResultsIn: aDirectory [

	| allBenchs result |
	aDirectory ensureCreateDirectory.
	allBenchs := self benchSuite.

	^ allBenchs collectWithIndex: [ :aBench :index |
		  Stdio stdout
			  << ('Running {1} / {2}...' format: {
							   index.
							   allBenchs size });
			  flush.
		  result := aBench run.
		  result serializeResultsInto: aDirectory.
		  Stdio stdout
			  << ' Ended';
			  crlf;
			  flush.
		  result ]
]

{ #category : #'accessing - defaults' }
BlBCase >> defaultDuration [
	
	^ 10 seconds 
]

{ #category : #accessing }
BlBCase >> defaultLabel [

	^ self class name asString
]

{ #category : #accessing }
BlBCase >> duration [
	
	^ duration ifNil: [ self defaultDuration ]
]

{ #category : #accessing }
BlBCase >> duration: aDuration [ 
	
	duration := aDuration
]

{ #category : #accessing }
BlBCase >> label [

	^ label ifNil: [ self defaultLabel ] 
]

{ #category : #accessing }
BlBCase >> label: aValue [

	label := aValue
]

{ #category : #'instance creation' }
BlBCase >> newColorGenerator [ 

	^ Generator on: [ :generator | 
		| nextIndex wheel|
		nextIndex := 1.
		wheel := Color wheel: 20.
		[ generator yield: (wheel at: nextIndex).
		nextIndex := (nextIndex + 1) \\ wheel size + 1 ] repeat ]
]

{ #category : #'instance creation' }
BlBCase >> newRandom [

	^ Random seed: 1
]

{ #category : #running }
BlBCase >> run [

	^ self runner runCase: self
]

{ #category : #running }
BlBCase >> runner [

	^ runner ifNil: [ runner := self defaultRunnerClass new ]
]
