Class {
	#name : #BlBAbstractTranslatingFiguresCase,
	#superclass : #BlBBlocCase,
	#instVars : [
		'useSingleAnimation'
	],
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #benchmarking }
BlBAbstractTranslatingFiguresCase class >> benchMatrix [

	^ super benchMatrix
		  forSelector: #useSingleAnimation
		  addOptions: #( true false )
]

{ #category : #running }
BlBAbstractTranslatingFiguresCase class >> isAbstract [

	^ self == BlBAbstractTranslatingFiguresCase
]

{ #category : #accessing }
BlBAbstractTranslatingFiguresCase >> defaultLabel [

	^ super defaultLabel , ' singleAnimation: ' ,  useSingleAnimation printString
]

{ #category : #accessing }
BlBAbstractTranslatingFiguresCase >> figureOffset [

	^ 20 @ 20
]

{ #category : #hook }
BlBAbstractTranslatingFiguresCase >> newElement [

	^ useSingleAnimation
		  ifTrue: [ self newElementWithSingleAnimation ]
		  ifFalse: [ self newElementWithIndependentAnimations ]
]

{ #category : #hook }
BlBAbstractTranslatingFiguresCase >> newElementWithIndependentAnimations [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self spaceExtent;
		yourself.

	1 to: self numberOfFigures do: [ :index |
		| aFigure |
		aFigure := self newFigureWith: random.
		aFigure position: self figureOffset + ((index * self offsetBetweenFigures x) @ 0).
		aFigure addAnimation: ((BlTransformAnimation translate: self targetTranslation)
		  duration: self duration;
		  yourself).
		
		container addChild: aFigure ].

	^ container
]

{ #category : #hook }
BlBAbstractTranslatingFiguresCase >> newElementWithSingleAnimation [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self spaceExtent;
		addAnimation: ((BlTransformAnimation translate: self targetTranslation)
		  duration: self duration;
		  yourself);
		yourself.

	1 to: self numberOfFigures do: [ :index |
		| aFigure |
		aFigure := self newFigureWith: random.
		aFigure position: self figureOffset + ((index * self offsetBetweenFigures x) @ 0).
		container addChild: aFigure ].

	^ container
]

{ #category : #hook }
BlBAbstractTranslatingFiguresCase >> newFigureWith: random [
	
	^ self subclassResponsibility
]

{ #category : #examples }
BlBAbstractTranslatingFiguresCase >> newSampleFigure [

	^ self newFigureWith: self newRandom
]

{ #category : #accessing }
BlBAbstractTranslatingFiguresCase >> numberOfFigures [

	^ 300
]

{ #category : #hook }
BlBAbstractTranslatingFiguresCase >> offsetBetweenFigures [

	^ 2 @ 0
]

{ #category : #hooks }
BlBAbstractTranslatingFiguresCase >> spaceExtent [

	^ 750 @ 350
]

{ #category : #accessing }
BlBAbstractTranslatingFiguresCase >> targetTranslation [

	^ 0 @ 200
]

{ #category : #accessing }
BlBAbstractTranslatingFiguresCase >> useSingleAnimation [

	^ useSingleAnimation
]

{ #category : #accessing }
BlBAbstractTranslatingFiguresCase >> useSingleAnimation: aBoolean [

	useSingleAnimation := aBoolean
]
