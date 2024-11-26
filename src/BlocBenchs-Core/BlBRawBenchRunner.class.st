Class {
	#name : #BlBRawBenchRunner,
	#superclass : #BlBAbstractBenchRunner,
	#instVars : [
		'sdlRenderer',
		'sdlWindow',
		'steppingProcess',
		'session',
		'delay',
		'stepError',
		'totalFrames',
		'currentFrames',
		'previousMillisecond',
		'fpsSamples'
	],
	#pools : [
		'SDL2Constants'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #running }
BlBRawBenchRunner >> cleanUpAfterCase: aBlBRawCase [

	steppingProcess ifNotNil: [ 
		steppingProcess terminate.
		steppingProcess := nil ].

	aBlBRawCase cleanUp.

	sdlRenderer ifNotNil: [
		sdlRenderer destroy.
		sdlRenderer := nil ].

	sdlWindow ifNotNil: [
		sdlWindow destroy.
		sdlWindow := nil ]
]

{ #category : #running }
BlBRawBenchRunner >> countFrames [


	| currentMillisecond fps |
	totalFrames := totalFrames + 1.
	currentFrames := currentFrames + 1.

	currentMillisecond := Time millisecondClockValue.
	
	(currentMillisecond >= (previousMillisecond + 1000))
		ifTrue: [ 
			fps := (currentFrames/ (currentMillisecond - previousMillisecond / 1000)) asFloat.
			fpsSamples add: { currentMillisecond. fps }.
			previousMillisecond := currentMillisecond.
			currentFrames := 0]

]

{ #category : #running }
BlBRawBenchRunner >> defaultMeters [
	
	^ super defaultMeters , { BlBRawRenderingMeter new }
]

{ #category : #running }
BlBRawBenchRunner >> doRun: aBlBRawCase [ 

	self startSteppingProcess: aBlBRawCase.
	delay := aBlBRawCase duration asDelay.
	delay wait.
	
	stepError ifNotNil: [ BlBError signalFor: stepError ]

]

{ #category : #running }
BlBRawBenchRunner >> doStep: aBlBRawCase [

	[ aBlBRawCase stepRender. 
	  self countFrames ] onErrorDo: [
		:e |
		stepError := e freeze.
		delay delaySemaphore signal.
		steppingProcess terminate ]
]

{ #category : #accessing }
BlBRawBenchRunner >> fpsSamples [ 

	^ fpsSamples 
]

{ #category : #running }
BlBRawBenchRunner >> prepareBeforeRun: aBlBRawCase [

	sdlWindow := SDL2
		             createWindow: aBlBRawCase label
		             x: aBlBRawCase position x
		             y: aBlBRawCase position y
		             width: aBlBRawCase extent x
		             height: aBlBRawCase extent y
		             flags: SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI. "| SDL_WINDOW_OPENGL"

	sdlRenderer := sdlWindow createDefaultRenderer.
	
	aBlBRawCase beforeRunRenderer: sdlRenderer window: sdlWindow.
	
	totalFrames := 0.
	fpsSamples := OrderedCollection new.
	previousMillisecond := Time millisecondClockValue.
	currentFrames := 0	
]

{ #category : #running }
BlBRawBenchRunner >> startSteppingProcess: aBlBRawCase [

	steppingProcess := [
		session := Smalltalk session.
		[ session == Smalltalk session ] 
			whileTrue: [ self doStep: aBlBRawCase ] ] newProcess.

	steppingProcess
			name: 'Step Loop ', self asString;
			priority: Processor userSchedulingPriority;
			resume
]

{ #category : #accessing }
BlBRawBenchRunner >> totalFrames [
	^ totalFrames
]
