Class {
	#name : #PCLayerCompositionBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-FPS'
}

{ #category : #accessing }
PCLayerCompositionBenchCase >> borderWidth [
	
	^ 5
]

{ #category : #hook }
PCLayerCompositionBenchCase >> indexOfElementToRefresh [

	^ self subclassResponsibility 
]

{ #category : #accessing }
PCLayerCompositionBenchCase >> indexOfOverlappedElement [

	^ self numberOfFigures - 5
]

{ #category : #accessing }
PCLayerCompositionBenchCase >> indexOfTopElement [

	^ self numberOfFigures
]

{ #category : #hook }
PCLayerCompositionBenchCase >> newColorGenerator [ 

	^ Generator on: [ :generator | 
		| nextIndex wheel|
		nextIndex := 1.
		wheel := Color wheel: 20.
		[ generator yield: (wheel at: nextIndex).
		nextIndex := (nextIndex + 1) \\ wheel size + 1 ] repeat ]
]

{ #category : #hook }
PCLayerCompositionBenchCase >> newElement [

	| random container |
	random := self newRandom.
		
	container := BlElement new
		size: self surfaceExtent;
		yourself.

	1 to: self numberOfFigures do: [ :index |
		container addChild: (self newFigure: random) ].
	
	self
		prepareToRefresh: (container children at: self indexOfElementToRefresh)
		random: random.

	^ container
]

{ #category : #hook }
PCLayerCompositionBenchCase >> newFigure: random [
	
	^ BlElement new
			background: self theForm;
			size: self theForm extent;
			relocate: (self nextLocation: random);
			border: (BlBorder paint: Color black width: self borderWidth);
			yourself
]

{ #category : #hook }
PCLayerCompositionBenchCase >> nextLocation: random [

	^ (random nextInteger: self surfaceExtent x - self theForm extent x)
	  @ (random nextInteger: self surfaceExtent y - self theForm extent y)
]

{ #category : #accessing }
PCLayerCompositionBenchCase >> numberOfFigures [

	^ 50
]

{ #category : #hook }
PCLayerCompositionBenchCase >> prepareToRefresh: anElement random: aRandom [

	| colorGenerator |
	colorGenerator := self newColorGenerator.

	anElement
		beInSeparateCompositionLayer;
		addAnimation: (BlBasicAnimation new
				 onStepDo: [ 
					 anElement border:
							 (BlBorder paint: colorGenerator next width: self borderWidth) ];
				 yourself)
]

{ #category : #accessing }
PCLayerCompositionBenchCase >> surfaceExtent [

	^ 750 @ 750
]

{ #category : #hook }
PCLayerCompositionBenchCase >> theForm [

	^ Smalltalk ui icons iconNamed: #pharoBig
]
