Class {
	#name : #BlBResultsByVersion,
	#superclass : #Object,
	#instVars : [
		'version',
		'runs'
	],
	#category : #'BlocBenchs-Core-Exporter'
}

{ #category : #accessing }
BlBResultsByVersion >> runs: aCollection [ 
	
	runs := aCollection
]

{ #category : #versions }
BlBResultsByVersion >> version: aString [ 
	
	version := aString
]

{ #category : #'as yet unclassified' }
BlBResultsByVersion >> versionTicks [

	| filtered last |
	filtered := runs reject: [ :e | e fpsSamples isEmpty ].
	filtered ifEmpty: [ ^ { BlBResultsTemplates dashIcon } ].

	last := filtered last.

	^ filtered collect: [ :e |
		  last == e
			  ifTrue: [ BlBResultsTemplates equalsIcon ]
			  ifFalse: [
				  (last isBetterThan: e)
					  ifTrue: [ BlBResultsTemplates checkIcon ]
					  ifFalse: [ BlBResultsTemplates crossIcon ] ] ]
]
