Class {
	#name : #PCTranslatingFiguresBenchCase,
	#superclass : #PCBenchCase,
	#instVars : [
		'useSingleAnimation'
	],
	#category : 'BlocBenchs-FPS-Cases'
}

{ #category : #examples }
PCTranslatingFiguresBenchCase class >> exampleOpenFigureSamples [

	self allBenchCases do: [ :each |
		| sampleElement |
		sampleElement := each newSampleFigure.

		BlSpace new
			addChild: (sampleElement
				position: 50 asPoint;
				yourself);
			title: 'Sample: ', each label;
			extent: 400 asPoint;
			show ]

]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> figureOffset [

	^ 20 @ 20
]

{ #category : #initialization }
PCTranslatingFiguresBenchCase >> initialize [

	super initialize.
	
	useSingleAnimation := true
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> logicalExtent [

	^ 750 @ 350
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> newElement [

	^ useSingleAnimation
		  ifTrue: [ self newElementWithSingleAnimation ]
		  ifFalse: [ self newElementWithIndependentAnimations ]
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> newElementWithIndependentAnimations [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self logicalExtent;
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
PCTranslatingFiguresBenchCase >> newElementWithSingleAnimation [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self logicalExtent;
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
PCTranslatingFiguresBenchCase >> newFigureWith: random [
	
	^ self subclassResponsibility
]

{ #category : #examples }
PCTranslatingFiguresBenchCase >> newSampleFigure [

	^ self newFigureWith: self newRandom
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> numberOfFigures [

	^ 300
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> offsetBetweenFigures [

	^ 2 @ 0
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> targetTranslation [

	^ 0 @ 200
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> useSingleAnimation [

	^ useSingleAnimation
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> useSingleAnimation: aBoolean [

	useSingleAnimation := aBoolean
]
