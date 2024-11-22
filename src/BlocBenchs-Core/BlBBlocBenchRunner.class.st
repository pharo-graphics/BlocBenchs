Class {
	#name : #BlBBlocBenchRunner,
	#superclass : #Object,
	#instVars : [
		'space',
		'result',
		'meters',
		'duration'
	],
	#category : #'BlocBenchs-Core'
}

{ #category : #'as yet unclassified' }
BlBBlocBenchRunner >> cleanUpAfterCase [
	
	space ifNil: [ ^ self ].
	
	space close.
	space spaceStatistics ifNotNil: [ :stats | stats spaceClosed ].

]

{ #category : #running }
BlBBlocBenchRunner >> defaultMeters [

	^ {
		  BlBTimeMeter new.
		  BlBRenderingMeter new.
		  BlAllocationsMeter new }
]

{ #category : #'as yet unclassified' }
BlBBlocBenchRunner >> doRun: aBlBBlocCase [ 
	
	duration 
		ifNotNil: [ aBlBBlocCase duration: duration ]
		ifNil: [ duration := aBlBBlocCase duration ].
	
	space extent: aBlBBlocCase spaceExtent.	
	space root addChild: aBlBBlocCase newElement.	
	space root children first requestFocus.		
	space show. 
	aBlBBlocCase duration wait.
	
	
]

{ #category : #accessing }
BlBBlocBenchRunner >> duration: aDuration [ 
	duration := aDuration
]

{ #category : #running }
BlBBlocBenchRunner >> meters [

	^ meters ifNil: [ meters := self defaultMeters ]
]

{ #category : #'as yet unclassified' }
BlBBlocBenchRunner >> prepareBeforeRun [
	
	space := BlSpace new
]

{ #category : #running }
BlBBlocBenchRunner >> reportMeters [

	self meters do: [:e | e reportResultsFrom: self in: result].
]

{ #category : #running }
BlBBlocBenchRunner >> runCase: aCase [

	result := BlBResult new.
	result initializeFrom: aCase.

	^ [
		self prepareBeforeRun.
		self startMeters.
		self doRun: aCase.
		self stopMeters.
		self reportMeters.
		result 
	] ensure: [ self cleanUpAfterCase ]
]

{ #category : #accessing }
BlBBlocBenchRunner >> space [
	^ space
]

{ #category : #running }
BlBBlocBenchRunner >> startMeters [

	self meters do: [:e | e startMetering: self].
]

{ #category : #running }
BlBBlocBenchRunner >> stopMeters [

	self meters reverse do: [:e | e stopMetering: self].
]
