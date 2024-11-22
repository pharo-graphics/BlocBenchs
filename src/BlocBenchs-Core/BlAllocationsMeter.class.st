Class {
	#name : #BlAllocationsMeter,
	#superclass : #BlBMeter,
	#instVars : [
		'initialAllocationBytes',
		'finalAllocationBytes'
	],
	#category : #'BlocBenchs-Core'
}

{ #category : #'as yet unclassified' }
BlAllocationsMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [

	aBlBResult
		addField: #allocatedBytes
		title: 'Allocated Memory (Bytes)'
		value: finalAllocationBytes - initialAllocationBytes
]

{ #category : #'as yet unclassified' }
BlAllocationsMeter >> startMetering: aBlBBlocBenchRunner [ 
	
	initialAllocationBytes := Smalltalk vm getParameters at: 34.
]

{ #category : #'as yet unclassified' }
BlAllocationsMeter >> stopMetering: aBlBBlocBenchRunner [ 
	
	finalAllocationBytes := Smalltalk vm getParameters at: 34.
]
