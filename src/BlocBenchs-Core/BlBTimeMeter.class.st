Class {
	#name : #BlBTimeMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'initialTime',
		'finalTime'
	],
	#category : #'BlocBenchs-Core'
}

{ #category : #'as yet unclassified' }
BlBTimeMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 
	
	aBlBResult 
		addField: #totalTime 
		title: 'Total Time (ms)'
		value: finalTime - initialTime.

]

{ #category : #'as yet unclassified' }
BlBTimeMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	initialTime := Time millisecondClockValue 
]

{ #category : #'as yet unclassified' }
BlBTimeMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	finalTime := Time millisecondClockValue 
]
