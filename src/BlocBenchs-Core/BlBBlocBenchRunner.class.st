Class {
	#name : #BlBBlocBenchRunner,
	#superclass : #BlBAbstractBenchRunner,
	#instVars : [
		'space',
		'stopSemaphore'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #running }
BlBBlocBenchRunner >> cleanUpAfterCase: aBlBCase [
	
	| semaphore |
	super cleanUpAfterCase: aBlBCase.
	
	space ifNil: [ ^ self ].
	
	semaphore := Semaphore new.
	space
		addEventHandlerOn: BlSpaceClosedEvent
		do: [ semaphore signal ].
	space close.
	semaphore wait.
	self assert: space isOpened not.

	space spaceStatistics ifNotNil: [ :stats | stats spaceClosed ].

]

{ #category : #running }
BlBBlocBenchRunner >> defaultMeters [

	^  super defaultMeters , { BlBBlocRenderingMeter new }
]

{ #category : #running }
BlBBlocBenchRunner >> doRun: aBlBBlocCase [ 
	
	stopSemaphore := Semaphore new.
		
	space extent: aBlBBlocCase spaceExtent.	
	space root addChild: aBlBBlocCase newElement.	
	space root children first requestFocus.
	space show.
	
	self flag: #todo. "See: https://github.com/pharo-graphics/Bloc/issues/767"
	space addEventHandlerOn: BlSpaceShownEvent doOnce: [
		space center.
		stopSemaphore signal ].

	stopSemaphore wait.
	
	stopSemaphore waitTimeoutMilliseconds: aBlBBlocCase duration asMilliSeconds.
	
	
]

{ #category : #running }
BlBBlocBenchRunner >> prepareBeforeRun: aBlBCase [
	
	space := BlSpace new.
	space title: aBlBCase label.
	space enableStatistics.
]

{ #category : #accessing }
BlBBlocBenchRunner >> space [
	^ space
]

{ #category : #accessing }
BlBBlocBenchRunner >> stop [

	stopSemaphore signal
]

{ #category : #accessing }
BlBBlocBenchRunner >> totalFrames [

	^ self space spaceStatistics totalFrames
]
