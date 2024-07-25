"
I help to filter and print the results of `SpaceTally` for Bloc, Toplo, Album, and Alexandrie.
"
Class {
	#name : #BlbSpaceTallyPrinter,
	#superclass : #Object,
	#instVars : [
		'spaceTally'
	],
	#category : #'BlocBenchs-Printing'
}

{ #category : #examples }
BlbSpaceTallyPrinter class >> runToStdout [
	<example>

	3 timesRepeat: [ Smalltalk garbageCollect ].
	self new run; reportOnStdout
]

{ #category : #examples }
BlbSpaceTallyPrinter class >> runToTranscript [
	<example>

	3 timesRepeat: [ Smalltalk garbageCollect ].
	self new run; reportOnTranscript
]

{ #category : #printing }
BlbSpaceTallyPrinter >> reportAsString [

	^ String streamContents: [ :aStream | self reportOn: aStream ]
]

{ #category : #printing }
BlbSpaceTallyPrinter >> reportOn: aStream [

	| filteredItems df |

	filteredItems := ((spaceTally results items select: [ :a |
		a analyzedClassName matchesRegex: '(To|Bl|Ae|Alb)[A-Z].*' ])
			asSortedCollection: [ :a :b |
				a spaceForInstances > b spaceForInstances ]) asArray.

	df := DataFrame withColumnNames: #('instances' 'bytes').
	filteredItems do: [ :aSpaceTallyItem |
		df
			addRow: {
				aSpaceTallyItem instanceCount printString.
				aSpaceTallyItem spaceForInstances printString }
			named: aSpaceTallyItem analyzedClassName ].
	DataFrameMarkdownPrinter new
		dataFrame: df;
		stream: aStream;
		write
]

{ #category : #printing }
BlbSpaceTallyPrinter >> reportOnStdout [

	Stdio stdout lf.
	self reportOn: Stdio stdout.
	Stdio stdout lf; flush
]

{ #category : #printing }
BlbSpaceTallyPrinter >> reportOnTranscript [

	Transcript cr.
	self reportOn: Transcript.
	Transcript cr; flush
]

{ #category : #running }
BlbSpaceTallyPrinter >> run [

	spaceTally := SpaceTally new.
	spaceTally systemWideSpaceTally
]
