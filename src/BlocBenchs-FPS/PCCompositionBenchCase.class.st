Class {
	#name : #PCCompositionBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #accessing }
PCCompositionBenchCase >> figureExtent [

	^ 25 asPoint
]

{ #category : #accessing }
PCCompositionBenchCase >> layerExtent [

	^ self logicalExtent / 2
]

{ #category : #accessing }
PCCompositionBenchCase >> logicalExtent [

	^ 900 @ 900
]

{ #category : #hook }
PCCompositionBenchCase >> newElement [

	| random backgroundColorGenerator container staticComplexElement |
	random := self newRandom.
	backgroundColorGenerator := self newColorGenerator.

	container :=
		BlElement new
			size: self logicalExtent;
			addAnimation: (BlBasicAnimation new
				onStepDo: [ :target | target background: backgroundColorGenerator next ];
				yourself);
			yourself.

	"static"
	staticComplexElement := BlElement new
		background: Color transparent;
		size: self layerExtent;
		yourself.
	1 to: self numberOfFigures do: [ :index |
		staticComplexElement addChild: (self newFigure: random) ].
	container addChild: staticComplexElement.
	self prepareAsStatic: staticComplexElement.

	^ container
]

{ #category : #hook }
PCCompositionBenchCase >> newFigure: random [
	
	^ BlElement new
		background: (Color random: random);
		relocate: (self nextLocation: random);
		size: self figureExtent;
		yourself
]

{ #category : #hook }
PCCompositionBenchCase >> nextLocation: random [

	^ (random nextInteger: self layerExtent x - self figureExtent x)
	  @ (random nextInteger: self layerExtent y - self figureExtent y)
]

{ #category : #accessing }
PCCompositionBenchCase >> numberOfFigures [

	^ 5000
]

{ #category : #hook }
PCCompositionBenchCase >> prepareAsStatic: anElement [

	self subclassResponsibility
]
