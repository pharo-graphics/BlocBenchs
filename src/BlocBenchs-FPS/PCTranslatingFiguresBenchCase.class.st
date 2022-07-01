Class {
	#name : #PCTranslatingFiguresBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #examples }
PCTranslatingFiguresBenchCase class >> exampleOpenFigureSamples [

	self allBenchCases do: [ :each |
		| sampleElement |
		sampleElement := each newSampleFigure.

		BlSpace new
			addChild: (sampleElement
				relocate: 50 asPoint;
				yourself);
			title: 'Sample: ', each label;
			extent: 400 asPoint;
			show ]

]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> figureOffset [

	^ 20 @ 20
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> horizontalSeparation [

	^ 2
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> logicalExtent [

	^ 750 @ 350
]

{ #category : #hook }
PCTranslatingFiguresBenchCase >> newElement [

	| random container |
	random := self newRandom.
	container := BlElement new
		size: self logicalExtent;
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

{ #category : #examples }
PCTranslatingFiguresBenchCase >> newSampleFigure [

	^ self newFigureWith: self newRandom
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> numberOfFigures [

	^ 300
]

{ #category : #accessing }
PCTranslatingFiguresBenchCase >> targetTranslation [

	^ 0 @ 200
]
