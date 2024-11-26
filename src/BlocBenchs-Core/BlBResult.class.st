Class {
	#name : #BlBResult,
	#superclass : #Object,
	#instVars : [
		'content',
		'caseClassName',
		'caseLabel'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #adding }
BlBResult >> addField: aFieldName title: aTitle value: aValue [ 
	
	self content at: aFieldName put: { aTitle. aValue }
]

{ #category : #accessing }
BlBResult >> content [
	
	^ content ifNil: [ content := Dictionary new ]
]

{ #category : #initialization }
BlBResult >> initializeFrom: aBlBCase [ 
	
	caseClassName := aBlBCase class name.
	caseLabel := aBlBCase label
]
