"
I'm in charge of profiling cases.

A case can be profiled in two ways:
- #run, profiles the body.
- #runOnOpen, profiles only the opening.

See my class-side for an example.

"
Class {
	#name : #BlProfileRunner,
	#superclass : #Object,
	#instVars : [
		'case',
		'meters'
	],
	#category : #'BlocBenchs-Old-ProfileCases'
}

{ #category : #examples }
BlProfileRunner class >> casesToProfile [

	^ { BlBoidsProfileCase new }
]

{ #category : #examples }
BlProfileRunner class >> exampleAll [

	| cases runners |
	cases := self casesToProfile.
	runners := self hostClassesToProfile flatCollect: [ :eachHostClass |
		cases collect: [ :eachCase |
			| case |
			case := eachCase copy
				hostClass: eachHostClass;
				yourself.

			(BlProfileRunner newForCase: case)
				enableFPS;
				enableFFILogger;
				enableFFICounter;
				enableASProfiler;
				yourself

			] ].

	[	runners do: #run.
		runners do: #openMeterReports ] fork.

]

{ #category : #examples }
BlProfileRunner class >> exampleMinimalFPS [
	
	[ 	| case |
		case := BlBoidsProfileCase new
			hostClass: BlOSWindowSDL2Host;
			duration: 7 seconds;
			yourself.

		(BlProfileRunner newForCase: case)
			enableFPS;
			run;
			openMeterReports ] fork
]

{ #category : #examples }
BlProfileRunner class >> exampleOnlyFFI [

	| cases runners |
	cases := self casesToProfile.
	runners := self hostClassesToProfile flatCollect: [ :eachHostClass |
		cases collect: [ :eachCase |
			| case |
			case := eachCase copy
				hostClass: eachHostClass;
				yourself.

			(BlProfileRunner newForCase: case)
				enableFFICounter;
				enableFFILogger;
				yourself

			] ].

	[	runners do: #run.
		runners do: #openMeterReports ] fork

]

{ #category : #examples }
BlProfileRunner class >> exampleOnlyFPS [

	| cases runners |
	cases := self casesToProfile.
	runners := self hostClassesToProfile flatCollect: [ :eachHostClass |
		cases collect: [ :eachCase |
			| case |
			case := eachCase copy
				hostClass: eachHostClass;
				yourself.

			(BlProfileRunner newForCase: case)
				enableFPS;
				yourself

			] ].

	[	runners do: #run.
		runners do: #openMeterReports ] fork.

]

{ #category : #examples }
BlProfileRunner class >> exampleOnlyFlameGraph [

	| cases runners |
	cases := self casesToProfile.
	runners := self hostClassesToProfile flatCollect: [ :eachHostClass |
		cases collect: [ :eachCase |
			| case |
			case := eachCase copy
				hostClass: eachHostClass;
				yourself.

			(BlProfileRunner newForCase: case)
				enableASProfiler;
				yourself

			] ].

	[	runners do: #run.
		runners do: #openMeterReports ] fork.

]

{ #category : #examples }
BlProfileRunner class >> hostClassesToProfile [

	^ { BlOSWindowSDL2Host "BlMorphicWindowHost" }
]

{ #category : #'instance creation' }
BlProfileRunner class >> newForCase: aProfileCase [

	^ self new
		  case: aProfileCase;
		  yourself
]

{ #category : #accessing }
BlProfileRunner >> addMeter: aMeter [

	meters add: aMeter
]

{ #category : #accessing }
BlProfileRunner >> case [

	^ case
]

{ #category : #accessing }
BlProfileRunner >> case: aProfileCase [ 
	
	case := aProfileCase 
]

{ #category : #convenience }
BlProfileRunner >> enableASProfiler [
	
	self addMeter: BlAndreasSystemProfiler new
]

{ #category : #convenience }
BlProfileRunner >> enableFFICounter [

	self addMeter: BlFFICounter new
]

{ #category : #convenience }
BlProfileRunner >> enableFFILogger [

	self addMeter: BlFFILogger new
]

{ #category : #convenience }
BlProfileRunner >> enableFPS [
	
	self addMeter: BlFrameMeter new
]

{ #category : #initialization }
BlProfileRunner >> initialize [

	super initialize.
	
	meters := OrderedCollection new.
]

{ #category : #accessing }
BlProfileRunner >> meters [

	^ meters
]

{ #category : #API }
BlProfileRunner >> openMeterReports [

	| notebook meterPresenters |
	notebook := SpNotebookPresenter new.
	meterPresenters := meters flatCollect: [ :each | 
		                   each reportsAsPagesUsing: notebook ].

	meterPresenters do: [ :each | notebook addPage: each ].

	notebook
		addPageTitle: 'Raw'
		provider: [ Smalltalk tools inspector onObject: self ].

	notebook open
		title: case shortDescription;
		extent: 800 @ 600
]

{ #category : #printing }
BlProfileRunner >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: case;
		nextPut: $)

]

{ #category : #API }
BlProfileRunner >> reportMeterReportsOnStdout [

	| logStream |
	logStream := Stdio stdout.

	logStream nextPutAll: case shortDescription; lf.

	meters do: [ :each | 
		logStream 
			nextPutAll: each asString;
			lf;
			nextPutAll: each reportAsString;
			lf ].

	logStream nextPutAll: '---'; lf.
]

{ #category : #running }
BlProfileRunner >> run [
	"Profile the body of the case."

	self withBlocParametersDo: [ 
		case openSpace.
		[ self withStartedMetersDo: [ case executeBody ] ] 
			ensure: [ case closeSpace ] ]
]

{ #category : #running }
BlProfileRunner >> runOnOpen [
	"Profile the opening of the case."

	self withBlocParametersDo: [ 
		[ self withStartedMetersDo: [ case openSpace ] ]
			ensure: [ case closeSpace ] ]

]

{ #category : #private }
BlProfileRunner >> withBlocParametersDo: aBlockClosure [

	case space host: case hostClass new.
	aBlockClosure value.

]

{ #category : #private }
BlProfileRunner >> withStartedMetersDo: aBlockClosure [

	meters do: [ :each |
		each 
			case: case;
			startMetering ].

	aBlockClosure ensure: [

		meters reverseDo: [ :each |
			each stopMetering ] ]

]
