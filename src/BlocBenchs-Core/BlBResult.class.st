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
BlBResult >> content [
	
	^ content ifNil: [ content := Dictionary new ]
]

{ #category : #accessing }
BlBResult >> error: anError [

	error := anError
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
