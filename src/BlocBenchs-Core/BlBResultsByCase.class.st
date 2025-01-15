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
BlBResultsByCase >> mustacheDefaultWhenLookupFails [ 

	self error
]

{ #category : #versions }
BlBResultsByCase >> versionTicks [

	^ allVersionsNames collect: [ :e |
		  versions
			  at: e
			  ifPresent: [ :x | x versionTicks ]
			  ifAbsent: { BlBResultsTemplates dashIcon } ]
]

{ #category : #'instance creation' }
BlBResultsByCase >> versions: aCollection [ 
	
	versions := aCollection 
]
