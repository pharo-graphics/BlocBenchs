Class {
	#name : #BlBMeter,
	#superclass : #Object,
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #reporting }
BlBMeter >> reportResultsFrom: aBlBBlocBenchRunner in: aBlBResult [

]

{ #category : #mettering }
BlBMeter >> startMetering: aBlBBlocBenchRunner [ 
	^ self subclassResponsibility
]

{ #category : #mettering }
BlBMeter >> stopMetering: aBlBBlocBenchRunner [ 
	^ self subclassResponsibility
]
