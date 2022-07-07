Class {
	#name : #PCCirclesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCCirclesBenchCase >> newFigureWith: random [

	^ BlElement new
		geometry: BlCircleGeometry new;
		size: self radius * 2;
		in:[ :me | self prepare: me with: random ];
		yourself

]

{ #category : #accessing }
PCCirclesBenchCase >> numberOfFigures [

	^ 100
]

{ #category : #accessing }
PCCirclesBenchCase >> offsetBetweenFigures [

	^ 6 @ 0
]

{ #category : #hook }
PCCirclesBenchCase >> prepare: anElement with: random [

	^ self subclassResponsibility
]

{ #category : #accessing }
PCCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
