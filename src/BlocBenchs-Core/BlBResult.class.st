Class {
	#name : #BlBResult,
	#superclass : #Object,
	#instVars : [
		'content',
		'caseClassName',
		'caseLabel',
		'dateAndTime',
		'id',
		'hasError',
		'error'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #'ston-core' }
BlBResult class >> stonAllInstVarNames [ 

	^ super stonAllInstVarNames copyWithout: #error
]

{ #category : #adding }
BlBResult >> addField: aFieldName title: aTitle value: aValue [ 
	
	self content at: aFieldName put: { aTitle. aValue }
]

{ #category : #'as yet unclassified' }
BlBResult >> blocVersion [

	^ (self contentAt: #repositoriesVersions) 
		detect: [ :e | e first sameAs: 'bloc' ]
		ifFound: [ :e | e second ]
		ifNone: [ #unknown ]
]

{ #category : #accessing }
BlBResult >> caseLabel [
	^ caseLabel
]

{ #category : #accessing }
BlBResult >> confidenceInterval [
	
	| avg deviation |
	
	avg := self fpsSamples average.
	
	deviation := MeanConfidenceIntervalPrinter new
		gaussianConfidenceFactor: 2;
		confidenceIntervalFor: self fpsSamples.
		
	^ { avg - deviation. avg + deviation }
]

{ #category : #accessing }
BlBResult >> content [
	
	^ content ifNil: [ content := Dictionary new ]
]

{ #category : #accessing }
BlBResult >> contentAt: aKey [

	^ (content at: aKey) second
]

{ #category : #accessing }
BlBResult >> date [
	
	^ dateAndTime asDate 
]

{ #category : #accessing }
BlBResult >> error: anError [

	error := anError
]

{ #category : #accessing }
BlBResult >> fpsSamples [

	^ (self contentAt: #fpsSamples) in: [ :anOrderedCollection |
		  anOrderedCollection
			  ifEmpty: [ anOrderedCollection ]
			  ifNotEmpty: [
			  anOrderedCollection allButFirst collect: [ :e | e second ] ] ]
]

{ #category : #hook }
BlBResult >> frameCount [
	
	^ self contentAt: #frameCount
]

{ #category : #accessing }
BlBResult >> hasError [
	^ hasError
]

{ #category : #accessing }
BlBResult >> imageVersion [
	
	^ self contentAt: #imageVersion.
]

{ #category : #accessing }
BlBResult >> imageVersionGroups [

	| fullImageVersion matcher |
	fullImageVersion := self imageVersion.

	matcher := '.*-(\d+\.\d+.\d+).*build\.(\d+)\..*' asRegex.
	(matcher matches: fullImageVersion) 
		ifFalse: [ self error: 'Cannot parse imageVersion' ].

	^ {matcher subexpression: 2. matcher subexpression: 3}
]

{ #category : #initialization }
BlBResult >> initializeFrom: aBlBCase [ 
	
	caseClassName := aBlBCase class name.
	caseLabel := aBlBCase label.
	dateAndTime := DateAndTime now.
	id := UUID new asString.
	hasError := false.
]

{ #category : #testing }
BlBResult >> isBetterThan: aBlBResult [ 
	
	| mine other |
	mine := self confidenceInterval.
	other := aBlBResult confidenceInterval.
	
	^ mine second > other second or: [ mine second between: other first and: other second ]
]

{ #category : #accessing }
BlBResult >> mainImageVersion [

	^ self imageVersionGroups first
]

{ #category : #'as yet unclassified' }
BlBResult >> osName [

	^ self contentAt: #osName
]

{ #category : #printing }
BlBResult >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: caseLabel asString;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
BlBResult >> serializeErrorInto: aDirectory [

	FLDebuggerStackSerializer
		serializeStackFromContext: error signalerContext
		toFileNamed: ((aDirectory / id) withExtension: 'fuel') fullName
]

{ #category : #'as yet unclassified' }
BlBResult >> serializeResultsInto: aDirectory [ 
	
	| stonFile |
	
	hasError := error isNotNil.
	hasError ifTrue: [ self serializeErrorInto: aDirectory ].
	
	stonFile := (aDirectory / id) withExtension: 'ston'.
	
	stonFile writeStreamDo: [ :aStream |  
		STON put: self onStreamPretty: aStream ].

]

{ #category : #'as yet unclassified' }
BlBResult >> shortBlocToploVersion [
	
	| versions toploCommit blocCommit | 
	
	versions := self contentAt: #repositoriesVersions.
	toploCommit := (versions detect: [ :e | e first sameAs: 'toplo' ]) third first: 8.
	blocCommit := (versions detect: [ :e | e first sameAs: 'bloc' ]) third first: 8.
	
	^ 'T{1}-B{2}' format: { toploCommit. blocCommit }
]

{ #category : #accessing }
BlBResult >> shortImageVersion [
		
	^ '{1}-{2}' format: self imageVersionGroups.

]

{ #category : #'as yet unclassified' }
BlBResult >> shortVMVersion [
	
	| matcher |

	matcher := '.*v(\d+\.\d+\.\d+).* Commit\: (\w+) .*' asRegex.
	matcher matches: (self contentAt: #vmVersion).
	
	^ '{1}-{2}' format: { matcher subexpression: 2. matcher subexpression: 3 }

]

{ #category : #accessing }
BlBResult >> versionIdentifier [

	^ '{1}-{2}-{3}-{4}' format: { self shortImageVersion. self shortVMVersion. self shortBlocToploVersion. self osName}
]
