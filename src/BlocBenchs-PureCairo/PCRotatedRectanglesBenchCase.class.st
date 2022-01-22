Class {
	#name : #PCRotatedRectanglesBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCRotatedRectanglesBenchCase >> figureExtent [

	^ 100.0 asPoint
]

{ #category : #accessing }
PCRotatedRectanglesBenchCase >> label [

	^ 'Bordered rectangles'
]

{ #category : #hook }
PCRotatedRectanglesBenchCase >> newElement [

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
			transformDo: [ :aBuilder | aBuilder rotateBy: 10 ];
			border: (BlBorder paint: (Color random: random) width: 5);
			background: (Color random: random);
			size: self figureExtent;
			geometry: BlRectangleGeometry new;
			yourself) ].

	^ container	
]

{ #category : #hook }
PCRotatedRectanglesBenchCase >> newMorph [

	^ self notYetImplemented
]

{ #category : #hook }
PCRotatedRectanglesBenchCase >> numberOfFigures [

	^ 300
]
