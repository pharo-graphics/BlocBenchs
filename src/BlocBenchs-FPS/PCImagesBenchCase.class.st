Class {
	#name : #PCImagesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-FPS'
}

{ #category : #hook }
PCImagesBenchCase >> horizontalSeparation [

	^ 20
]

{ #category : #hook }
PCImagesBenchCase >> newFigureWith: random [

	| container verticalSeparation |
	verticalSeparation := self horizontalSeparation.
	container := BlElement new.
	container clipChildren: false.
	
	1 to: self numberOfRows do:[ :index |
		container addChild: 
			((self newImageElementWith: random)
				relocate: (0 @ index * verticalSeparation);
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

{ #category : #accessing }
PCImagesBenchCase >> surfaceExtent [

	^ 700 @ 700
]
