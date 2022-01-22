Class {
	#name : #PCEmptyCirclesBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCEmptyCirclesBenchCase >> label [

	^ 'Empty circles'
]

{ #category : #hook }
PCEmptyCirclesBenchCase >> newElement [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self surfaceExtent;
		addAnimation: ((BlTransformAnimation translate: 0 @ 200)
		  duration: numberOfSeconds seconds;
		  yourself).

	1 to: self numberOfFigures do: [ :index |
		container addChild: (BlElement new
			relocate: (index * 2) @ 0;
			border: (BlBorder paint: (Color random: random) width: 5);
			size: self radius * 2;
			geometry: BlCircleGeometry new;
			yourself) ].

	^ container	
]

{ #category : #hook }
PCEmptyCirclesBenchCase >> newMorph [

	^ self notYetImplemented
]

{ #category : #hook }
PCEmptyCirclesBenchCase >> numberOfFigures [

	^ 300
]

{ #category : #hook }
PCEmptyCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
