Class {
	#name : #BlBResultsByVersion,
	#superclass : #Object,
	#instVars : [
		'version',
		'runs'
	],
	#category : #'BlocBenchs-Core-Exporter'
}

{ #category : #'public - configuration' }
BlBResultsByVersion >> average [

	| samples |
	samples := runs flatCollect: [ :e | e fpsSamples ].
	^ samples average
]

{ #category : #accessing }
BlBResultsByVersion >> confidenceInterval [

	| samples avg deviation |

	samples := runs flatCollect: [:e | e fpsSamples].
	avg := samples average. 
	
	deviation := MeanConfidenceIntervalPrinter new
		gaussianConfidenceFactor: 2;
		confidenceIntervalFor: samples.
		
	^ { avg - deviation. avg + deviation }
]

{ #category : #testing }
BlBResultsByVersion >> isBetterThan: aBlBResultsByVersion [

	| mine other |
	mine := self confidenceInterval.
	other := aBlBResultsByVersion confidenceInterval.

	^ mine second > other second or: [
		  mine second between: other first and: other second ]
]

{ #category : #accessing }
BlBResultsByVersion >> runs: aCollection [ 
	
	runs := aCollection
]

{ #category : #accessing }
BlBResultsByVersion >> version [
	^ version
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
