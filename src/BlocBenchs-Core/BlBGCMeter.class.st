Class {
	#name : #BlBGCMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'finalFullGCCount',
		'initialFullGCCount',
		'finalIncrementalGCCount',
		'initialIncrementalGCCount',
		'initialFullGCTime',
		'initialIncrementalGCTime',
		'finalFullGCTime',
		'finalIncrementalGCTime'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #reporting }
BlBGCMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [

	aBlBResult
		addField: #fullGCCount
		title: 'Number of Full GCs'
		value: finalFullGCCount - initialFullGCCount.
		
	aBlBResult
		addField: #incrementalGCCount
		title: 'Number of Incremental GCs'
		value: finalIncrementalGCCount - initialIncrementalGCCount	.
		
	aBlBResult
		addField: #fullGCTotalTime
		title: 'Incremental GC Total Time (in ms)'
		value: finalFullGCTime - initialFullGCTime.
			
	aBlBResult
		addField: #incrementalGCTotalTime
		title: 'Incremental GC Total Time (in ms)'
		value: finalIncrementalGCTime - initialIncrementalGCTime				
]

{ #category : #mettering }
BlBGCMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	"We force a GC to have better statistics"
	Smalltalk garbageCollect.
	
	initialFullGCCount := Smalltalk vm fullGCCount.
	initialIncrementalGCCount := Smalltalk vm incrementalGCCount.
	initialFullGCTime := Smalltalk vm totalFullGCTime.
	initialIncrementalGCTime := Smalltalk vm totalIncrementalGCTime.
	 
]

{ #category : #mettering }
BlBGCMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	finalFullGCCount := Smalltalk vm fullGCCount.
	finalIncrementalGCCount := Smalltalk vm incrementalGCCount.
	finalFullGCTime := Smalltalk vm totalFullGCTime.
	finalIncrementalGCTime := Smalltalk vm totalIncrementalGCTime.

]
