"
Benchmarks to compare Sparta andd Athens-Cairo.


Example of use:
~~~
[
	{
	PCBlocBenchmarker new beSkia; yourself.
	PCBlocBenchmarker new beCairo; yourself.
	PCBlocNullRendererBenchmarker new.
	PCAthensBenchmarker new.
	} do: [:each |
		Smalltalk garbageCollect. 1 second wait.
		each
			run;
			shortReportOnStdout;
			reportOnTranscript ]
] fork
~~~
"
Class {
	#name : #PCBenchmarker,
	#superclass : #Object,
	#instVars : [
		'loggedCalls',
		'loggedCallsRanking',
		'numberOfSeconds',
		'loggedStartTime',
		'loggedDuration',
		'includesFFILogging',
		'loggedFrameCount'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCBenchmarker >> closeWindow [

	self subclassResponsibility
	

]

{ #category : #accessing }
PCBenchmarker >> enableFFILogging [

	includesFFILogging := true
]

{ #category : #hook }
PCBenchmarker >> frameCount [

	^ self subclassResponsibility
]

{ #category : #initializing }
PCBenchmarker >> initialize [

	super initialize.
	
	numberOfSeconds := 5.
	includesFFILogging := false.
]

{ #category : #printing }
PCBenchmarker >> label [

	^ self subclassResponsibility
]

{ #category : #hook }
PCBenchmarker >> openWindow [
	
	self subclassResponsibility

]

{ #category : #hook }
PCBenchmarker >> realStartTimestamp [

	^ self subclassResponsibility
]

{ #category : #printing }
PCBenchmarker >> report [

	^ String streamContents: [ :aStream | self reportOn: aStream ]
]

{ #category : #printing }
PCBenchmarker >> reportAsString [

	^ String streamContents: [ :stream | self reportOn: stream ]
]

{ #category : #printing }
PCBenchmarker >> reportOn: aStream [

	aStream << '# '; <<  self label; lf; lf.

	aStream << 'Speed: '.
	(loggedFrameCount / numberOfSeconds) printOn: aStream showingDecimalPlaces: 2.
	aStream << 'fps'; lf.

	aStream << 'Real Duration: '.
	loggedDuration totalSeconds printOn: aStream showingDecimalPlaces: 3.
	aStream << 's'; lf.
	
	includesFFILogging ifTrue: [ 
		aStream << 'Top FFI Calls:'; lf; lf.
		DataFrameMarkdownPrinter new
			stringBlockClosure: [ :o :r :c |
				(o isNumber
					ifTrue: [ o printShowingDecimalPlaces: 1 ]
					ifFalse: [ o ]) asString ];
			dataFrame: (loggedCallsRanking head: 15);
			stream: aStream;
			write.
		].

	aStream lf; lf.

]

{ #category : #printing }
PCBenchmarker >> reportOnStdout [

	self reportOn: Stdio stdout
]

{ #category : #printing }
PCBenchmarker >> reportOnTranscript [

	self reportAsString withInternalLineEndings traceCr
]

{ #category : #running }
PCBenchmarker >> run [

	includesFFILogging ifTrue: [ self startLogging ].
	self openWindow.
	numberOfSeconds seconds wait.

	loggedFrameCount := self frameCount.
	loggedDuration := DateAndTime now - self realStartTimestamp.
	includesFFILogging ifTrue: [ self stopLogging ].

	self closeWindow.

]

{ #category : #running }
PCBenchmarker >> runInFork [

	[ self run ] fork
]

{ #category : #printing }
PCBenchmarker >> shortReportOn: aStream [

	aStream << self label; << ': '.
	(loggedFrameCount / numberOfSeconds) printOn: aStream showingDecimalPlaces: 1.
	aStream << 'fps'; lf; lf.

]

{ #category : #printing }
PCBenchmarker >> shortReportOnStdout [

	self shortReportOn: Stdio stdout
]

{ #category : #private }
PCBenchmarker >> startLogging [

	"Ensure prepared"
	TFLCallLogger
		install;
		resetInstance.
	TFLCallLogger instance entryCount: 20000.
	TFLFunctionCounter resetInstance.

	"Really start"
	TFLCallLogger instance start.
	TFLFunctionCounter start.

]

{ #category : #private }
PCBenchmarker >> stopLogging [

	| functionNamesSeries callsPerFrameSeries |


	loggedCalls := TFLCallLogger instance copy.
	TFLCallLogger stop; resetInstance.



	loggedCallsRanking := TFLFunctionCounter instance functionNamesAndCounts.
	functionNamesSeries := loggedCallsRanking keys asDataSeries
		name: 'Function names';
		yourself.
	callsPerFrameSeries := (loggedCallsRanking values
		collect: [ :value | (value / loggedFrameCount) asFloat ]) asDataSeries
			name: 'Calls per Frame';
			yourself.
	
	loggedCallsRanking := (DataFrame withRowNames: functionNamesSeries)
		addColumn: callsPerFrameSeries;
		sortDescendingBy: callsPerFrameSeries name;
		yourself.

	TFLFunctionCounter stop; resetInstance.

]
