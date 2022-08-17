"
Benchmarks to compare several rendering implementations.

See examples in my class-side.

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
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #'as yet unclassified' }
PCBenchmarker class >> exampleAllBenchsForBloc [

	[ PCBenchCase allBenchCases do: [ :eachCase |
		eachCase numberOfSeconds: 3.

		{
		 PCBlocRegularRendererBenchmarker new beSkia; yourself.
		 PCBlocRegularRendererBenchmarker new beCairo; yourself.
		 PCBlocAlexandrieBenchmarker new.
		 PCBlocNullRendererBenchmarker new.
		} do: [ :eachBenchmarker | 
			Smalltalk garbageCollect. 1 second wait.
			eachBenchmarker
			   case: eachCase;
			   run;
			   shortReportOnStdout;
			   shortReportOnTranscript ] ]	

	] fork.

]

{ #category : #'as yet unclassified' }
PCBenchmarker class >> exampleAllBenchsWithRaw [
	"Note: Not all `PCBenchCase` respond to `newRawSDLCairoWindow`."

	[ PCBenchCase allBenchCasesWithRaw do: [ :eachCase |
		eachCase numberOfSeconds: 3.

		{
		 PCBlocRegularRendererBenchmarker new beSkia; yourself.
		 PCBlocRegularRendererBenchmarker new beCairo; yourself. 
		 PCBlocAlexandrieBenchmarker new.
		 PCRawBenchmarker new.
		} do: [ :eachBenchmarker | 
			Smalltalk garbageCollect. 1 second wait.
			eachBenchmarker
			   case: eachCase;
			   run;
			   shortReportOnStdout;
			   shortReportOnTranscript ] ]	

	] fork.

]

{ #category : #'as yet unclassified' }
PCBenchmarker class >> exampleAllSDL2Drivers [

	| case driverNames |
	case := PCBoxWindmillBenchCase new.
	"case := PCCompositionEnabledBenchCase new."
	case numberOfSeconds: 4.

	driverNames := (SDL2 renderDriverInfos collect: #nameString) copyWithout: 'opengles2'.
	"opengles2 crashed on a a MacbookPro 2018"

	[	driverNames do: [ :eachRendererName |
			SDL2 setHint: 'SDL_RENDER_DRIVER' value: eachRendererName.
			SDL2 setHint: 'SDL_RENDER_BATCHING' value: '1'.
			SDL2 setHint: 'SDL_FRAMEBUFFER_ACCELERATION' value: '1'.

			Smalltalk garbageCollect. 1 second wait.

			PCRawBenchmarker new
				case: case;
				run;
				shortReportOnStdout;
				shortReportOnTranscript ]
	] fork.


]

{ #category : #'as yet unclassified' }
PCBenchmarker class >> exampleBenchAllCasesOneCanvas [

	| p b w |
	p := [
		PCBenchCase allBenchCases 
			do: [ :eachCase |
				b := PCBlocAlexandrieBenchmarker new.
				b 	case: eachCase;
					run;
					shortReportOnStdout;
					reportOnTranscript ].
		w close.
	] fork.

	w := SpButtonPresenter new 
		label: 'Stop now';
		action: [ p terminate. b closeWindow. w close ];
		open.

]

{ #category : #'as yet unclassified' }
PCBenchmarker class >> exampleProfileCase [
	"Opens a flame-graph on the AndreasSystemProfiler."

	[ | report |
		report := SaReport newWithASPOn: [

		| element space |
		element := PCBoxWindmillBenchCase new newElement.
		space := BlSpace new
			host: BAOSWindowSDL2Host new;
			addChild: element;
			show;
			yourself.
		5 seconds wait.
		space close.

		].

		report
			colorMap: (SaCategoryPrefixColorMap new 
					mapPrefixes: #(
						'Fenster'
						'Alexandrie'
						'Sparta')
						from: Color purple;
					mapPrefixes: #(
						'BlocHost'
						'Bloc-Text'
						'Bloc')
						from: Color orange;
					mapPrefixes: #(
						'BlocPac'
						'Brick'
						'Spec-Brick')
						from: Color lightBlue;
					yourself);
				inspect
		] fork.

]

{ #category : #'as yet unclassified' }
PCBenchmarker class >> exampleProfileNull [
	"Profile the overhead of Bloc without rendering"

	WorldState MinCycleLapse: 1. "By default, 16"
	[ PCBlocNullRendererBenchmarker new
		case: PCSolidCirclesBenchCase new;
		run ] fork.
	AndreasSystemProfiler spyOnWorldFor: 5.
]

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

{ #category : #printing }
PCBenchmarker >> fpsReportAsString [

	^ String streamContents: [ :stream | self fpsReportOn: stream ]
]

{ #category : #printing }
PCBenchmarker >> fpsReportOn: aStream [

	(loggedFrameCount / case numberOfSeconds) printOn: aStream showingDecimalPlaces: 1.
	aStream lf.

]

{ #category : #printing }
PCBenchmarker >> fpsReportOnStdout [

	self fpsReportOn: Stdio stdout
]

{ #category : #printing }
PCBenchmarker >> fpsReportOnTranscript [

	self fpsReportAsString withInternalLineEndings trace
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

{ #category : #printing }
PCBenchmarker >> labelWithCase [

	^ self label, ' - ', case label
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

	aStream << '# '; <<  self labelWithCase; lf; lf.

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

	self reportAsString withInternalLineEndings trace
]

{ #category : #running }
PCBenchmarker >> run [

	"Start log"
	mustLogFFI ifTrue: [ self startFFILogging ].

	[
		"Main sentences under benchmark"
		self openWindow.
		case duration wait.

		"End log"
		loggedFrameCount := self frameCount.
		"(Zero frames indicate an error, e.g. drawing)"
		loggedFrameCount > 0 ifTrue: [
			loggedDuration := self elapsedTimeSinceFirstDraw.
			mustLogFFI ifTrue: [ self stopFFILogging ] ].

		] ensure: [ self closeWindow ]

]

{ #category : #printing }
PCBenchmarker >> shortReportAsString [

	^ String streamContents: [ :stream | self shortReportOn: stream ]
]

{ #category : #printing }
PCBenchmarker >> shortReportOn: aStream [

	aStream << self labelWithCase; << ': '.
	(loggedFrameCount / case numberOfSeconds) printOn: aStream showingDecimalPlaces: 1.
	aStream << 'fps'; lf.

]

{ #category : #printing }
PCBenchmarker >> shortReportOnStdout [

	self shortReportOn: Stdio stdout
]

{ #category : #printing }
PCBenchmarker >> shortReportOnTranscript [

	self shortReportAsString withInternalLineEndings trace
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
