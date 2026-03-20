Class {
	#name : #BlBBlocBenchFrameRunner,
	#superclass : #BlBBlocBenchRunner,
	#instVars : [
		'frames',
		'framesLimit'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #'as yet unclassified' }
BlBBlocBenchFrameRunner class >> forFrames: aLimit [

	^ self new
		framesLimit: aLimit;
		yourself
]

{ #category : #running }
BlBBlocBenchFrameRunner >> framesLimit: aLimit [

	framesLimit := aLimit
]

{ #category : #running }
BlBBlocBenchFrameRunner >> initialize [ 

	super initialize.
	framesLimit := 100.
]

{ #category : #running }
BlBBlocBenchFrameRunner >> prepareSpace [

	frames := 0.
	space addEventHandlerOn: BlSpaceRenderEndEvent do: [
			frames := frames + 1.
			frames >= framesLimit ifTrue: [ stopSemaphore signal ] ]
]

{ #category : #running }
BlBBlocBenchFrameRunner >> waitForEndFor: aBlBBlocCase [

	stopSemaphore wait
]
