"
I'm a profiling case with an animated BlElement.
"
Class {
	#name : #BlBAbstractSimpleAnimationCase,
	#superclass : #BlBBlocCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #running }
BlBAbstractSimpleAnimationCase class >> isAbstract [ 

	^ self == BlBAbstractSimpleAnimationCase 
]

{ #category : #hooks }
BlBAbstractSimpleAnimationCase >> newElement [

	^ BlElement new
		position: 100 asPoint;
		extent: 100 asPoint;
		border: (BlBorder paint: Color gray width: 4);
		addAnimation: (self newSteppingAnimation);
		yourself
]

{ #category : #'instance creation' }
BlBAbstractSimpleAnimationCase >> newSteppingAnimation [

	^ self subclassResponsibility
]
