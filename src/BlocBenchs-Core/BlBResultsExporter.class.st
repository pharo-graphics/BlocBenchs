Class {
	#name : #BlBResultsExporter,
	#superclass : #Object,
	#instVars : [
		'resultsDirectory',
		'results',
		'groups'
	],
	#category : #'BlocBenchs-Core-Exporter'
}

{ #category : #'as yet unclassified' }
BlBResultsExporter >> ensureGroups [

	^ groups ifNil: [
		  groups := (results groupedBy: [ :e | e caseLabel ]) collect: [ :e |
			            e groupedBy: [ :x | x versionIdentifier ] ] ]
]

{ #category : #'as yet unclassified' }
BlBResultsExporter >> ensureResults [

	results ifNotNil: [ ^ results ].

	results := (resultsDirectory glob: [ :e | e isFile and: [ e extension = 'ston' ] ]) 
					collect: [ :e | self tryToReadResult: e ] as: OrderedCollection.
					
	^ results removeAllSuchThat: [:e | e isNil].
]

{ #category : #accessing }
BlBResultsExporter >> plots [
	
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
		boxPlot build
	]
]

{ #category : #'as yet unclassified' }
BlBResultsExporter >> resultsDirectory: aFileLocator [ 

	resultsDirectory := aFileLocator 
	
]

{ #category : #'as yet unclassified' }
BlBResultsExporter >> tryToReadResult: aDiskDirectoryEntry [

	^ [ STON fromString: aDiskDirectoryEntry asFileReference contents ]
		  onErrorDo: [ :e |
			  ('Rejecting file: '
			   , aDiskDirectoryEntry asFileReference fullName) traceCr.
			  nil ]
]
