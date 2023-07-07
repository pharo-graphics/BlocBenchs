Class {
	#name : #PCImagesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #accessing }
PCImagesBenchCase >> logicalExtent [

	^ 700 @ 700
]

{ #category : #hook }
PCImagesBenchCase >> newFigureWith: random [

	| container |
	container := BlElement new.
	container clipChildren: false.
	
	1 to: self numberOfRows do:[ :index |
		container addChild:
			((self newImageElementWith: random)
				position: 0 @ (index * self offsetBetweenFigures y);
				yourself) ].

	^ container
]

{ #category : #hook }
PCImagesBenchCase >> newFormWith: random [

	^ Smalltalk ui icons icons atRandom: random
]

{ #category : #hook }
PCImagesBenchCase >> newImageElementWith: random [

	^ self subclassResponsibility
]

{ #category : #accessing }
PCImagesBenchCase >> numberOfColumns [

	^ 30
]

{ #category : #accessing }
PCImagesBenchCase >> numberOfFigures [

	^ self numberOfColumns
]

{ #category : #accessing }
PCImagesBenchCase >> numberOfRows [

	^ 20
]

{ #category : #hook }
PCImagesBenchCase >> offsetBetweenFigures [

	^ 20 @ 20
]
