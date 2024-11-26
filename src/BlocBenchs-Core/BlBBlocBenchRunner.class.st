Class {
	#name : #BlBBlocBenchRunner,
	#superclass : #BlBAbstractBenchRunner,
	#instVars : [
		'space'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #running }
BlBBlocBenchRunner >> cleanUpAfterCase: aBlBCase [
	
	space ifNil: [ ^ self ].
	
	space close.
	space spaceStatistics ifNotNil: [ :stats | stats spaceClosed ].

]

{ #category : #running }
BlBBlocBenchRunner >> defaultMeters [

	^  super defaultMeters , { BlBBlocRenderingMeter new }
]

{ #category : #running }
BlBBlocBenchRunner >> doRun: aBlBBlocCase [ 
		
	space extent: aBlBBlocCase spaceExtent.	
	space root addChild: aBlBBlocCase newElement.	
	space root children first requestFocus.		
	space show. 
	aBlBBlocCase duration wait.
	
	
]

{ #category : #running }
BlBBlocBenchRunner >> prepareBeforeRun: aBlBCase [
	
	space := BlSpace new.
	space enableStatistics.	
]

{ #category : #accessing }
BlBBlocBenchRunner >> space [
	^ space
]

{ #category : #accessing }
BlBBlocBenchRunner >> totalFrames [

	^ self space spaceStatistics totalFrames
]
