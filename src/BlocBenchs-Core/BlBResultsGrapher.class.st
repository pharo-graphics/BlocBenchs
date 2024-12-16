Class {
	#name : #BlBResultsGrapher,
	#superclass : #Object,
	#instVars : [
		'resultsDirectory',
		'results',
		'groups'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #'as yet unclassified' }
BlBResultsGrapher >> ensureGroups [
	
	^ groups ifNil: [ groups := results groupedBy: [ :e | e caseLabel ] ]
]

{ #category : #'as yet unclassified' }
BlBResultsGrapher >> ensureResults [

	results ifNotNil: [ ^ results ].

	results := (resultsDirectory glob: [ :e | e isFile and: [ e extension = 'ston' ] ]) 
					collect: [ :e | self tryToReadResult: e ] as: OrderedCollection.
					
	^ results removeAllSuchThat: [:e | e isNil].
]

{ #category : #accessing }
BlBResultsGrapher >> plots [
	
	| aCaseLabel data labels boxPlot |
	self ensureResults.
	self ensureGroups.

	^ groups collect: [ :someCases | 
		aCaseLabel := someCases first caseLabel.
		data := someCases collect: [ :e | e fpsSamples ].
		labels := someCases collect: [ :e | e shortImageVersion ].

		boxPlot := RSBoxPlot data: data.
		boxPlot xTickLabels: labels.
		boxPlot title: aCaseLabel.
		boxPlot 	
	]
]

{ #category : #'as yet unclassified' }
BlBResultsGrapher >> resultsDirectory: aFileLocator [ 

	resultsDirectory := aFileLocator 
	
]

{ #category : #'as yet unclassified' }
BlBResultsGrapher >> tryToReadResult: aDiskDirectoryEntry [

	^ [ STON fromString: aDiskDirectoryEntry asFileReference contents ]
		  onErrorDo: [ :e |
			  ('Rejecting file: '
			   , aDiskDirectoryEntry asFileReference fullName) traceCr.
			  nil ]
]
