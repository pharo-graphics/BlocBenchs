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

{ #category : #accessing }
BlBResult >> caseLabel [
	^ caseLabel
]

{ #category : #accessing }
BlBResult >> content [
	
	^ content ifNil: [ content := Dictionary new ]
]

{ #category : #accessing }
BlBResult >> error: anError [

	error := anError
]

{ #category : #accessing }
BlBResult >> fpsSamples [

	^ (content at: #fpsSamples) second in: [ :anOrderedCollection |
		  anOrderedCollection
			  ifEmpty: [ anOrderedCollection ]
			  ifNotEmpty: [
			  anOrderedCollection allButFirst collect: [ :e | e second ] ] ]
]

{ #category : #accessing }
BlBResult >> imageVersion [
	
	^ (content at: #imageVersion) second.
]

{ #category : #initialization }
BlBResult >> initializeFrom: aBlBCase [ 
	
	caseClassName := aBlBCase class name.
	caseLabel := aBlBCase label.
	dateAndTime := DateAndTime now.
	id := UUID new asString.
	hasError := false.
]

{ #category : #'as yet unclassified' }
BlBResult >> osName [

	^ (content at: #osName) second
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
	
	versions := (content at: #repositoriesVersions) second.
	toploCommit := versions detect: [ :e | e first sameAs: 'toplo'  ] ifFound: [ :e | e third ].
	blocCommit := versions detect: [ :e | e first sameAs: 'bloc'  ] ifFound: [ :e | e third ].
	
	^ 'T{1}-B{2}' format: { toploCommit. blocCommit }
]

{ #category : #accessing }
BlBResult >> shortImageVersion [

	| fullImageVersion parts |
	fullImageVersion := self imageVersion.

	parts := (fullImageVersion allButFirst: 'Pharo-' size) splitOn: [ :e |
		         #( $. $+ ) includes: e ].

	^ '{1}.{2}.{3}-{6}' format: parts.

]

{ #category : #'as yet unclassified' }
BlBResult >> shortVMVersion [
	
	| matcher |

	matcher := '.*v(\d+\.\d+\.\d+).* Commit\: (\w+) .*' asRegex.
	matcher matches: (content at: #vmVersion) second.
	
	^ '{1}-{2}' format: { matcher subexpression: 2. matcher subexpression: 3 }

]

{ #category : #accessing }
BlBResult >> versionIdentifier [

	^ '{1}-{2}-{3}-{4}' format: { self shortImageVersion. self shortVMVersion. self shortBlocToploVersion. self osName}
]
