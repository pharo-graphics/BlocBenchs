Class {
	#name : #BlBAbstractBenchRunner,
	#superclass : #Object,
	#instVars : [
		'result',
		'meters',
		'duration'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #adding }
BlBAbstractBenchRunner >> addMeter: aBlBMeter [ 

	self meters add: aBlBMeter
]

{ #category : #'as yet unclassified' }
BlBAbstractBenchRunner >> cleanUpAfterCase: aBlBCase [ 
	^ self subclassResponsibility
]

{ #category : #running }
BlBAbstractBenchRunner >> defaultMeters [

	^ {
		  BlBTimeMeter new.
		  BlAllocationsMeter new.
		  BlBFFICounterMeter new }
]

{ #category : #'as yet unclassified' }
BlBAbstractBenchRunner >> doRun: aBlBBlocCase [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
BlBAbstractBenchRunner >> duration: aDuration [ 
	duration := aDuration
]

{ #category : #running }
BlBAbstractBenchRunner >> meters [

	^ meters ifNil: [ meters := self defaultMeters asOrderedCollection ]
]

{ #category : #running }
BlBAbstractBenchRunner >> reportMeters [

	self meters do: [:e | e reportResultsFrom: self in: result].
]

{ #category : #running }
BlBAbstractBenchRunner >> runCase: aCase [

	result := BlBResult new.
	result initializeFrom: aCase.

	^ [
		self prepareBeforeRun: aCase.
		self setDuration: aCase.
		self startMeters.
		self doRun: aCase.
		self stopMeters.
		self reportMeters.
		result 
	] ensure: [ self cleanUpAfterCase: aCase ]
]

{ #category : #running }
BlBAbstractBenchRunner >> setDuration: aCase [

	duration 
		ifNotNil: [ aCase duration: duration ]
		ifNil: [ duration := aCase duration ].

]

{ #category : #running }
BlBAbstractBenchRunner >> startMeters [

	self meters do: [:e | e startMetering: self].
]

{ #category : #running }
BlBAbstractBenchRunner >> stopMeters [

	self meters reverse do: [:e | e stopMetering: self].
]

{ #category : #'as yet unclassified' }
BlBAbstractBenchRunner >> totalFrames [
	^ self subclassResponsibility
]
