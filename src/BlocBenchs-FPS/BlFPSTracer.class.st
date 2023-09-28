"
I trace to Transcript animation statistics of a Bloc space.

See an example of use on my class side.
"
Class {
	#name : 'BlFPSTracer',
	#superclass : 'Object',
	#instVars : [
		'framesDeltaMS',
		'lastMS',
		'firstMS',
		'space',
		'delay',
		'loopProcess',
		'spaceShownEventHandler',
		'spaceRenderEndEventHandler'
	],
	#category : 'BlocBenchs-FPS-Utility',
	#package : 'BlocBenchs-FPS',
	#tag : 'Utility'
}

{ #category : 'examples' }
BlFPSTracer class >> exampleOfUse [
	"The #start adds a handler to the space shown event, then it should be added before space show."

	| space |
	space := BlSpace new.

	space root addAnimation:
		(BlColorTransition new
			from: Color green;
			to: Color red;
			beInfinite;
			onStepDo: [ :c :element | element background: c ]).

	BlFPSTracer startOnSpace: space.
	Transcript open.

	space extent: 100 asPoint.
	space show.

]

{ #category : 'instance creation' }
BlFPSTracer class >> newOnSpace: aSpace [

	^ self basicNew
		initializeOnSpace: aSpace;
		yourself
]

{ #category : 'instance creation' }
BlFPSTracer class >> startOnSpace: aBlSpace [ 

	^ (self newOnSpace: aBlSpace)
		start;
		yourself
]

{ #category : 'displaying' }
BlFPSTracer >> forkLoopProcess [

	loopProcess := [

		[	delay wait.

			framesDeltaMS ifNotEmpty: [
				self printStatsOn: Transcript.
				Transcript cr; flush ].
			self resetFramesDeltaMS.

			] doWhileTrue: [
				Processor activeProcess == loopProcess
				and: [ space isOpened ] ].

		self stop

	] forkNamed: self printString, ' Loop'

]

{ #category : 'displaying' }
BlFPSTracer >> initializeOnSpace: aSpace [

	self initialize.

	space := aSpace.
	delay := Delay forMilliseconds: 1000.
	
	"Our start happens when the space is actually shown."
	spaceShownEventHandler := BlEventHandler
		on: BlSpaceShownEvent
		do: [ :evt |
			firstMS := Time millisecondClockValue.
			lastMS := firstMS.
			self resetFramesDeltaMS.
			self forkLoopProcess ].

	"Each frame, register the elapsed time."
	spaceRenderEndEventHandler := BlEventHandler
		on: BlSpaceRenderEndEvent
		do: [ :evt |
			lastMS ifNotNil: [
				| currentMS |
				currentMS := Time millisecondClockValue.
				framesDeltaMS add: (currentMS - lastMS).
				lastMS := currentMS ] ].

]

{ #category : 'printing' }
BlFPSTracer >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self identityHash;
		nextPut: $)
]

{ #category : 'displaying' }
BlFPSTracer >> printStatsOn: aStream [

	aStream
		<< 'fps:	';
		print: framesDeltaMS size.
	
	aStream << ';	ms:	'.

	MeanConfidenceIntervalPrinter new
		fixedDecimalPlaces: 1;
		print: framesDeltaMS on: aStream

]

{ #category : 'displaying' }
BlFPSTracer >> resetFramesDeltaMS [

	framesDeltaMS := LinkedList new.

]

{ #category : 'displaying' }
BlFPSTracer >> start [

	self trace. ' start' traceCr.
	
	space
		addEventHandler: spaceShownEventHandler;
		addEventHandler: spaceRenderEndEventHandler

]

{ #category : 'displaying' }
BlFPSTracer >> stop [

	self trace. ' stop' traceCr.

	space
		removeEventHandler: spaceShownEventHandler;
		removeEventHandler: spaceRenderEndEventHandler.

	loopProcess ifNil: [ ^self ].
	loopProcess terminate.
	loopProcess := nil.


]
