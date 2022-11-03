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
		'mustLogFFI',
		'case',
		'loggedFramesDeltaMS'
	],
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #examples }
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

{ #category : #examples }
PCBenchmarker class >> exampleAllBenchsWithRaw [
	"Note: Not all `PCBenchCase` respond to `newRawSDLCairoWindow`."

	[ PCBenchCase allBenchCasesWithRaw do: [ :eachCase |
		eachCase numberOfSeconds: 2.

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

{ #category : #examples }
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

{ #category : #examples }
PCBenchmarker class >> exampleBenchAllCasesOneCanvas [

	| p b w |
	p := [
		PCBenchCase allBenchCases 
			do: [ :eachCase |
				b := PCBlocAlexandrieBenchmarker new.
				b 	case: eachCase;
					run;
					shortReportOnStdout;
					shortReportOnTranscript ].
		w close.
	] fork.

	w := SpButtonPresenter new 
		label: 'Stop now';
		action: [ p terminate. b closeWindow. w close ];
		open.

]

{ #category : #examples }
PCBenchmarker class >> exampleMinimizeLoopPeriods [

	{BlOSWindowSDL2Host. BAOSWindowSDL2Host } do: [ :each |
		each pulsePeriod: 1 milliSecond ].

	WorldState MinCycleLapse: 1. "By default, 16"

]

{ #category : #examples }
PCBenchmarker class >> exampleOneBench [

	| aCase |
	aCase := PCNestedTransformationsBenchCase new.
	aCase numberOfSeconds: 4.

	[ 
		{
		 PCBlocRegularRendererBenchmarker new beSkia; yourself.
		 PCBlocRegularRendererBenchmarker new beCairo; yourself.
		 PCBlocAlexandrieBenchmarker new.
		 PCBlocNullRendererBenchmarker new.
		} do: [ :eachBenchmarker | 
			Smalltalk garbageCollect. 1 second wait.
			eachBenchmarker
			   case: aCase;
			   run;
			   shortReportOnStdout;
			   shortReportOnTranscript ]

	] fork.

]

{ #category : #examples }
PCBenchmarker class >> exampleOutskirts [

	| p b w |
	p := [
		#(centered inside outside) do: [ :eachOutskirtsSelector |
			#(true false) do: [ :eachClipChildrenValue |
				#(beNoBackgroundColor beTranslucentBackgroundColor beOpaqueBackgroundColor)
					do: [ :eachBackgroundSelector |
						| eachCase |
						eachCase := PCOutskirtsBenchCase new
							perform: eachBackgroundSelector;
							outskirts: (BlOutskirts perform: eachOutskirtsSelector);
							mustClipChildren: eachClipChildrenValue;
							yourself.
						b := PCBlocAlexandrieBenchmarker new.
						b 	case: eachCase;
							run;
							shortReportOnStdout;
							shortReportOnTranscript ] ] ].
		w close.
	] fork.

	w := SpButtonPresenter new 
		label: 'Stop now';
		action: [ p terminate. b closeWindow. w close ];
		open.

]

{ #category : #examples }
PCBenchmarker class >> exampleProfileCase [
	"Opens a flame-graph on the AndreasSystemProfiler."

	[ | report |
		report := SaReport newWithASPOn: [

		| element space |
		element := PCRotatedTextBenchCase new newElement.
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
						'Alexandrie'
						'Sparta')
						from: Color purple;
					mapPrefixes: #(
						'Fenster'
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

{ #category : #examples }
PCBenchmarker class >> exampleProfileNull [
	"Profile the overhead of Bloc without rendering"

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

	self printFpsOn: aStream.
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

{ #category : #hook }
PCBenchmarker >> framesDeltaMS [

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
PCBenchmarker >> printFpsOn: aStream [

	loggedFramesDeltaMS size / loggedDuration totalSeconds
		printOn: aStream
		showingDecimalPlaces: 1
]

{ #category : #printing }
PCBenchmarker >> printFrameMSDurationStatsOn: aStream [

	PCMeanConfidenceIntervalPrinter new
		print: loggedFramesDeltaMS
		on: aStream

]

{ #category : #printing }
PCBenchmarker >> printProjectedFpsOn: aStream [

	| projectedFps |
	projectedFps := loggedFramesDeltaMS
		reject: [ :each | each isZero ]
		thenCollect: [ :each | 1000.0 / each ].
	PCMeanConfidenceIntervalPrinter new
		fixedDecimalPlaces: 1;
		print: projectedFps on: aStream.

]

{ #category : #printing }
PCBenchmarker >> reportFFIAsString [

	^ String streamContents: [ :stream | self reportFFIOn: stream ]
]

{ #category : #printing }
PCBenchmarker >> reportFFIOn: aStream [

	aStream << self labelWithCase; << ': '.

	DataFrameMarkdownPrinter new
		stringBlockClosure: [ :o :r :c |
			(o isNumber
				ifTrue: [ o printShowingDecimalPlaces: 1 ]
				ifFalse: [ o ]) asString ];
		dataFrame: (loggedCallsRanking head: 15);
		stream: aStream;
		write.

	aStream lf

]

{ #category : #printing }
PCBenchmarker >> reportFFIOnStdout [

	self reportFFIOn: Stdio stdout
]

{ #category : #printing }
PCBenchmarker >> reportFFIOnTranscript [

	self reportFFIAsString withInternalLineEndings trace
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
		loggedFramesDeltaMS := self framesDeltaMS.
		"Zero frames indicate an error, e.g. drawing"
		loggedFramesDeltaMS ifNotEmpty: [
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

	aStream
		<< self label;
		<< ';';
		<< case label;
		<< ';'.

	loggedDuration ifNil: [ 
		aStream << 'run error'; lf.
		^ self ].

	self printFpsOn: aStream.
"	aStream << ';'.
	self printFrameMSDurationStatsOn: aStream."
	aStream lf

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
		collect: [ :value | (value / loggedFramesDeltaMS size) asFloat ]) asDataSeries
			name: 'Calls per Frame';
			yourself.
	
	loggedCallsRanking := (DataFrame withRowNames: functionNamesSeries)
		addColumn: callsPerFrameSeries;
		sortDescendingBy: callsPerFrameSeries name;
		yourself.

	TFLFunctionCounter stop; resetInstance.

]
