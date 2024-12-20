Class {
	#name : #BlBResultsExporter,
	#superclass : #Object,
	#instVars : [
		'resultsDirectory',
		'results',
		'outputDirectory',
		'templates',
		'resultsByCase',
		'imageVersions'
	],
	#category : #'BlocBenchs-Core-Exporter'
}

{ #category : #'as yet unclassified' }
BlBResultsExporter >> ensureGroups [

	resultsByCase ifNotNil: [ ^ self ].

	imageVersions := (results collect: [ :e | e mainImageVersion ] as: Set) asOrderedCollection 
		sorted: [ :a :b | a < b]. 

	resultsByCase := (results groupedBy:[ :e | e caseLabel ]) associations 
		collect: [ :anAssoc | |byVersion versions|
			byVersion := anAssoc value groupedBy: [ :aCase | aCase mainImageVersion].
			versions := byVersion collect: [:runs | 
				BlBResultsByVersion new
					version: runs first mainImageVersion;
					runs: runs;
					yourself
				].
			
			BlBResultsByCase new
				caseLabel: anAssoc key;
				allVersionsNames: imageVersions;
				versions: versions;
				yourself
		]
]

{ #category : #'as yet unclassified' }
BlBResultsExporter >> ensureResults [

	results ifNotNil: [ ^ results ].

	results := (resultsDirectory glob: [ :e | e isFile and: [ e extension = 'ston' ] ]) 
					collect: [ :e | self tryToReadResult: e ] as: OrderedCollection.
					
	^ results removeAllSuchThat: [:e | e isNil].
]

{ #category : #accessing }
BlBResultsExporter >> exportResults [

	self ensureResults.
	self ensureGroups.

	outputDirectory ensureCreateDirectory.

	self generateIndex
]

{ #category : #'as yet unclassified' }
BlBResultsExporter >> generateFile: aFileReference fromTemplate: templateName withTitle: title andValues: values [

	aFileReference writeStreamDo: [ :aStream |
		aStream truncate.
		(ZnNewLineWriterStream on: aStream)
		 	nextPutAll:
				((templates perform: templateName) asMustacheTemplate
					 value: (values copyWith: (#pageTitle -> title))
					 partials: templates partials) ]
]

{ #category : #'as yet unclassified' }
BlBResultsExporter >> generateIndex [
	
	self 
		generateFile: outputDirectory / 'index.html'
		fromTemplate: #index
		withTitle: 'Bloc / Toplo Benchmarks Results'
		andValues: {#benchs -> resultsByCase. #imageVersions -> imageVersions } asDictionary
]

{ #category : #accessing }
BlBResultsExporter >> initialize [
	
	super initialize.

	outputDirectory := FileLocator imageDirectory / 'reports'.
	templates := BlBResultsTemplates new.
]

{ #category : #accessing }
BlBResultsExporter >> outputDirectory: aDirectory [

	outputDirectory := aDirectory 
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
