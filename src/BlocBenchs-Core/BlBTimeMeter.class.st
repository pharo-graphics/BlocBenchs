Class {
	#name : #BlBTimeMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'initialTime',
		'finalTime'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #reporting }
BlBTimeMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [ 
	
	aBlBResult 
		addField: #totalTime 
		title: 'Total Time (ms)'
		value: finalTime - initialTime.

]

{ #category : #mettering }
BlBTimeMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	initialTime := Time millisecondClockValue 
]

{ #category : #mettering }
BlBTimeMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	finalTime := Time millisecondClockValue 
]
