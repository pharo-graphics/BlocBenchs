Class {
	#name : #PCSolidCirclesBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCSolidCirclesBenchCase >> label [

	^ 'Solid circles translating'
]

{ #category : #hook }
PCSolidCirclesBenchCase >> newElement [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self surfaceExtent;
		addAnimation: ((BlTransformAnimation translate: 0 @ 200)
		  duration: numberOfSeconds seconds;
		  yourself).

	1 to: self numberOfCircles do: [ :index |
		container addChild: (BlElement new
			relocate: (index * 2) @ 0;
"			border: (BlBorder paint: (Color random: random) width: 1);"
			background: (Color random: random);
			size: self radius * 2;
			geometry: BlCircleGeometry new;
			yourself) ].

	^ container	
]

{ #category : #hook }
PCSolidCirclesBenchCase >> newMorph [

	^ PCTranslatingCirclesMorph new
		  surfaceExtent: self surfaceExtent;
		  numberOfCircles: self numberOfCircles;
		  radius: self radius;
		  yourself
]

{ #category : #hook }
PCSolidCirclesBenchCase >> numberOfCircles [

	^ 300
]

{ #category : #hook }
PCSolidCirclesBenchCase >> radius [

	^ 50.0 asPoint
]
