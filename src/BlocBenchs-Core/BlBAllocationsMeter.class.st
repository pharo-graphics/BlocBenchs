Class {
	#name : #BlBAllocationsMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'initialAllocationBytes',
		'finalAllocationBytes'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #reporting }
BlBAllocationsMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [

	aBlBResult
		addField: #allocatedBytes
		title: 'Allocated Memory (Bytes)'
		value: finalAllocationBytes - initialAllocationBytes
]

{ #category : #mettering }
BlBAllocationsMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	initialAllocationBytes := Smalltalk vm getParameters at: 34.
]

{ #category : #mettering }
BlBAllocationsMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	finalAllocationBytes := Smalltalk vm getParameters at: 34.
]
