Class {
	#name : #PCTranslatingFiguresBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> figureOffset [

	^ 20 @ 20
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> horizontalSeparation [

	^ 2
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> newElement [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self surfaceExtent;
		addAnimation: ((BlTransformAnimation translate: self targetTranslation)
		  duration: self duration;
		  yourself).

	1 to: self numberOfFigures do: [ :index |
		| aFigure |
		aFigure := self newFigureWith: random.
		aFigure relocate: self figureOffset + ((index * self horizontalSeparation) @ 0).
		container addChild: aFigure ].

	^ container
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> newFigureWith: random [
	
	^ self subclassResponsibility
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> numberOfFigures [

	^ 300
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> surfaceExtent [

	^ 750 @ 350
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> targetTranslation [

	^ 0 @ 200
]
