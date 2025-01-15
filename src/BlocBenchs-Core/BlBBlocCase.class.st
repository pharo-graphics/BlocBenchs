Class {
	#name : #BlBBlocCase,
	#superclass : #BlBCase,
	#category : #'BlocBenchs-Core-Core'
}

{ #category : #running }
BlBBlocCase class >> isAbstract [

	^ self == BlBBlocCase
]

{ #category : #utils }
BlBBlocCase >> angleInDegreesWith: random [
		
	^ random nextInteger: 360
]

{ #category : #accessing }
BlBBlocCase >> defaultRunnerClass [

	^ BlBBlocBenchRunner
]

{ #category : #'instance creation' }
BlBBlocCase >> newElement [

	^ self subclassResponsibility 
]

{ #category : #hooks }
BlBBlocCase >> spaceExtent [

	^ 800@600
]
