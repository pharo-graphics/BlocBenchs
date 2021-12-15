"
I'm a profiling case with an animated BlElement.
"
Class {
	#name : #BlSimpleElementProfileCase,
	#superclass : #BlFixedDurationProfileCase,
	#instVars : [
		'element'
	],
	#category : #'BlocBenchs-MeteringCases'
}

{ #category : #'instance creation' }
BlSimpleElementProfileCase >> newElement [

	^ element := BlElement new
		relocate: 100 asPoint;
		size: 100 asPoint;
		border: (BlBorder paint: Color gray width: 4);
		addAnimation: (self newSteppingAnimation);
		yourself
]

{ #category : #'instance creation' }
BlSimpleElementProfileCase >> newSteppingAnimation [

	^ self subclassResponsibility
]
