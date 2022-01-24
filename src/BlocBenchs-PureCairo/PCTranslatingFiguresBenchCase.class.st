Class {
	#name : #PCTranslatingFiguresBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> label [

	^ 'Solid circles'
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> newElement [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self surfaceExtent;
		addAnimation: ((BlTransformAnimation translate: 0 @ 200)
		  duration: numberOfSeconds seconds;
		  yourself).

	1 to: self numberOfFigures do: [ :index |
		| aFigure |
		aFigure := self newFigureWith: random.
		aFigure relocate: (index * 2) @ 0.
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
