Class {
	#name : #PCImagesBenchCase,
	#superclass : #PCTranslatingFiguresBenchCase,
	#category : #'BlocBenchs-PureCairo'
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
		| randomIcon |
		randomIcon := Smalltalk ui icons icons atRandom: random.
		
		container addChild: (BlElement new
"		  geometry: BlCircleGeometry new; --> doesn't work on Skia"
		  size: randomIcon extent;
		  background: randomIcon;
		  relocate: (0 @ index * verticalSeparation);
		  yourself) ].

	^ container
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
