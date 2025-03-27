Class {
	#name : #BlBBlocRunForNumberOfFrames,
	#superclass : #BlBMeter,
	#instVars : [
		'spaceStatistics',
		'runner',
		'frameCount',
		'frameLimit'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #testing }
BlBBlocRunForNumberOfFrames >> closed [
]

{ #category : #'as yet unclassified' }
BlBBlocRunForNumberOfFrames >> ensureStop [

	spaceStatistics ifNil: [ ^ self ].
	spaceStatistics spaceClosed.
	spaceStatistics := nil
]

{ #category : #testing }
BlBBlocRunForNumberOfFrames >> frameEnded [
	
	frameCount := frameCount + 1.
	frameCount >= frameLimit ifTrue: [ runner stop ].
]

{ #category : #initialization }
BlBBlocRunForNumberOfFrames >> initialize [

	frameCount := 0.
	frameLimit := 100
]

{ #category : #testing }
BlBBlocRunForNumberOfFrames >> refresh [

]

{ #category : #reporting }
BlBBlocRunForNumberOfFrames >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 

]

{ #category : #mettering }
BlBBlocRunForNumberOfFrames >> startMetering: aBlBBlocBenchRunner [ 
	
	runner := aBlBBlocBenchRunner.
	aBlBBlocBenchRunner space enableStatistics. 
	spaceStatistics := aBlBBlocBenchRunner space spaceStatistics.
	spaceStatistics registerListener: self.
]

{ #category : #mettering }
BlBBlocRunForNumberOfFrames >> stopMetering: aBlBBlocBenchRunner [ 
	
	self ensureStop
]
