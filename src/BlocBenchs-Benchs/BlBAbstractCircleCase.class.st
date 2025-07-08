Class {
	#name : #BlBAbstractCircleCase,
	#superclass : #BlBAbstractTranslatingFiguresCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #running }
BlBAbstractCircleCase class >> isAbstract [ 

	^ self == BlBAbstractCircleCase
]

{ #category : #hook }
BlBAbstractCircleCase >> newFigureWith: random [

	^ BlElement new
		geometry: BlCircleGeometry new;
		extent: self radius * 2;
		in:[ :me | self prepare: me with: random ];
		yourself

]

{ #category : #accessing }
BlBAbstractCircleCase >> numberOfFigures [

	^ 100
]

{ #category : #accessing }
BlBAbstractCircleCase >> offsetBetweenFigures [

	^ 6 @ 0
]

{ #category : #hook }
BlBAbstractCircleCase >> prepare: anElement with: random [

	^ self subclassResponsibility
]

{ #category : #accessing }
BlBAbstractCircleCase >> radius [

	^ 50.0 asPoint
]
