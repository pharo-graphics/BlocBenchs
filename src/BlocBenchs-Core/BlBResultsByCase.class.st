Class {
	#name : #BlBResultsByCase,
	#superclass : #Object,
	#instVars : [
		'caseLabel',
		'versions',
		'allVersionsNames'
	],
	#category : #'BlocBenchs-Core-Exporter'
}

{ #category : #'as yet unclassified' }
BlBResultsByCase >> allVersionsNames [

	^ allVersionsNames
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> allVersionsNames: aCollection [ 
	
	allVersionsNames := aCollection 
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> caseLabel [
	
	^ caseLabel
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> caseLabel: aString [ 
	
	caseLabel := aString 
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> caseLabelAsFileName [

	^ self caseLabel copyReplaceAll: ' ' with: '_'.
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> findBest [

	| maybeBest |
	maybeBest := (versions values sorted: [ :a :b | a isBetterThan: b ]) first.

	^ ((versions values copyWithout: maybeBest) noneSatisfy: [ :e |
		   e isBetterThan: maybeBest ])
		  ifTrue: [ maybeBest ]
		  ifFalse: [ nil ]
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> findBestImpact [
	
	| best |
	
	best := self findBest ifNil: [^ 0].

	^ (versions values copyWithout: best) 
		max: [ :e | best average / e average ]
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> findBestVersionName [
	
	^ self findBest ifNotNil: [ :e | e version ] ifNil: [ 'None' ]
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> mustacheDefaultWhenLookupFails [ 

	self error
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> resultsRow [
	
	| myTable best impact |
	
	myTable := self resultsTable.
	best := self findBestVersionName.
	impact := self findBestImpact. 

	^ Array streamContents: [ :stream | 
		stream nextPut: caseLabel.
		myTable do: [ :aVersion | stream nextPutAll: aVersion ].
		stream nextPut: best.
		stream nextPut: impact].
]

{ #category : #'as yet unclassified' }
BlBResultsByCase >> resultsTable [
	
	^ versions associations collect: [ :anAssoc |
		{ anAssoc key. anAssoc value confidenceInterval  } ]
]

{ #category : #versions }
BlBResultsByCase >> versionTicks [

	^ allVersionsNames collect: [ :e |
		  versions
			  at: e
			  ifPresent: [ :x | x versionTicks ]
			  ifAbsent: { BlBResultsTemplates dashIcon } ]
]

{ #category : #accessing }
BlBResultsByCase >> versions [
	^ versions
]

{ #category : #'instance creation' }
BlBResultsByCase >> versions: aCollection [ 
	
	versions := aCollection 
]
