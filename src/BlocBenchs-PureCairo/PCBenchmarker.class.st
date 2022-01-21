"
Benchmarks to compare Sparta andd Athens-Cairo.


Example of use:
~~~
[
	{
	PCBlocRegularRendererBenchmarker new beSkia; yourself.
	PCBlocRegularRendererBenchmarker new beCairo; yourself.
	PCBlocNullRendererBenchmarker new.
	PCBlocPCRendererBenchmarker new.
	PCMorphBenchmarker new.
	} do: [:each |
		Smalltalk garbageCollect. 1 second wait.
		each
			""enableFFILogging;""
			run;
			shortReportOnStdout;
			reportOnTranscript ]
] fork
~~~

It was also interesting to see:
~~~
WorldState MinCycleLapse: 1. ""By default, 16""
[ PCBlocNullRendererBenchmarker new run ] fork.
AndreasSystemProfiler spyOnWorldFor: 5.
~~~

"
Class {
	#name : #PCBenchmarker,
	#superclass : #Object,
	#instVars : [
		'loggedCalls',
		'loggedCallsRanking',
		'loggedStartTime',
		'loggedDuration',
		'loggedFrameCount',
		'mustLogFFI',
		'case'
	],
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBenchmarker >> case [

	^ case
]

{ #category : #accessing }
PCBenchmarker >> case: aPCBenchCase [

	case := aPCBenchCase
]

{ #category : #hook }
PCBenchmarker >> closeWindow [

	self subclassResponsibility
	

]

{ #category : #hook }
PCBenchmarker >> elapsedTimeSinceFirstDraw [

	^ self subclassResponsibility
]

{ #category : #accessing }
PCBenchmarker >> enableFFILogging [

	mustLogFFI := true
]

{ #category : #hook }
PCBenchmarker >> frameCount [

	^ self subclassResponsibility
]

{ #category : #initializing }
PCBenchmarker >> initialize [

	super initialize.
	
	mustLogFFI := false.
]

{ #category : #printing }
PCBenchmarker >> label [

	^ self subclassResponsibility
]

{ #category : #hook }
PCBenchmarker >> openWindow [
	
	self subclassResponsibility

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

	mustLogFFI
		ifFalse: [ 
			aStream << 'Speed: '.
			(loggedFrameCount / case numberOfSeconds) printOn: aStream showingDecimalPlaces: 2.
			aStream << 'fps'; lf.

			aStream << 'Real Duration: '.
			loggedDuration totalSeconds printOn: aStream showingDecimalPlaces: 3.
			aStream << 's'; lf ] 
		ifTrue: [ 
			aStream << 'Top FFI Calls:'; lf; lf.
			DataFrameMarkdownPrinter new
				stringBlockClosure: [ :o :r :c |
					(o isNumber
						ifTrue: [ o printShowingDecimalPlaces: 1 ]
						ifFalse: [ o ]) asString ];
				dataFrame: (loggedCallsRanking head: 15);
				stream: aStream;
				write.
			aStream lf ].


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

	"Start log"
	mustLogFFI ifTrue: [ self startFFILogging ].
	
	"Main sentences under benchmark"
	self openWindow.
	case numberOfSeconds seconds wait.

	"End log"
	loggedFrameCount := self frameCount.
	"(Zero frames indicate an error, e.g. drawing)"
	loggedFrameCount > 0 ifTrue: [
		loggedDuration := self elapsedTimeSinceFirstDraw.
		mustLogFFI ifTrue: [ self stopFFILogging ] ].

	self closeWindow.

]

{ #category : #running }
PCBenchmarker >> runInFork [

	[ self run ] fork
]

{ #category : #printing }
PCBenchmarker >> shortReportOn: aStream [

	aStream << self label; << ': '.
	(loggedFrameCount / case numberOfSeconds) printOn: aStream showingDecimalPlaces: 1.
	aStream << 'fps'; lf.

]

{ #category : #printing }
PCBenchmarker >> shortReportOnStdout [

	self shortReportOn: Stdio stdout
]

{ #category : #private }
PCBenchmarker >> startFFILogging [

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
PCBenchmarker >> stopFFILogging [

	| functionNamesSeries callsPerFrameSeries |

	"circular log"

	loggedCalls := TFLCallLogger instance copy.
	TFLCallLogger stop; resetInstance.

	"counter"

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
