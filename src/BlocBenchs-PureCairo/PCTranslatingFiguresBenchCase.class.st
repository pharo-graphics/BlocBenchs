Class {
	#name : #PCTranslatingFiguresBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCTranslatingFiguresBenchCase >> figureOffset [

	^ 20 @ 20
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
		aFigure relocate: self figureOffset + ((index * 2) @ 0).
		container addChild: aFigure ].

	^ container
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> newFigureWith: random [
	
	^ self subclassResponsibility
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> numberOfFigures [

	^ 300
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> surfaceExtent [

	^ 750 @ 350
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> targetTranslation [

	^ 0 @ 200
]
