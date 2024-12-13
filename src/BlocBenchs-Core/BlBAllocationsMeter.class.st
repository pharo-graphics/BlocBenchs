Class {
	#name : #BlBAllocationsMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'initialAllocationBytes',
		'finalAllocationBytes'
	],
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #'as yet unclassified' }
BlBAllocationsMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [

	aBlBResult
		addField: #allocatedBytes
		title: 'Allocated Memory (Bytes)'
		value: finalAllocationBytes - initialAllocationBytes
]

{ #category : #'as yet unclassified' }
BlBAllocationsMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	initialAllocationBytes := Smalltalk vm getParameters at: 34.
]

{ #category : #'as yet unclassified' }
BlBAllocationsMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	finalAllocationBytes := Smalltalk vm getParameters at: 34.
]
