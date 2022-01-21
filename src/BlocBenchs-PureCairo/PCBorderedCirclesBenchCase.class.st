Class {
	#name : #PCBorderedCirclesBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCBorderedCirclesBenchCase >> label [

	^ 'Bordered circles translating'
]

{ #category : #hook }
PCBorderedCirclesBenchCase >> newElement [

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
			border: (BlBorder paint: (Color random: random) width: 1);
			size: self radius * 2;
			geometry: BlCircleGeometry new;
			yourself) ].

	^ container	
]

{ #category : #hook }
PCBorderedCirclesBenchCase >> newMorph [

	^ self notYetImplemented
]

{ #category : #hook }
PCBorderedCirclesBenchCase >> numberOfFigures [

	^ 300
]

{ #category : #hook }
PCBorderedCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
