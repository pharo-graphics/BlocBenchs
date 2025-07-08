Class {
	#name : #BlBCompositionCase,
	#superclass : #BlBBlocCase,
	#traits : 'TBlBCompositionLogic',
	#classTraits : 'TBlBCompositionLogic classTrait',
	#instVars : [
		'useSingleComposition'
	],
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #benchmarking }
BlBCompositionCase class >> benchMatrix [ 

	^ ParametrizedTestMatrix new
			addCase: { #label -> 'BlBCompositionCase without using composition useSingleComposition: false'. 
						  #useSingleComposition -> false};
			addCase: { #label -> 'BlBCompositionCase without using composition useSingleComposition: true'. 
						  #useSingleComposition -> true};
			yourself
]

{ #category : #hook }
BlBCompositionCase >> newElement [

	| random backgroundColorGenerator container staticComplexElement |
	random := self newRandom.
	backgroundColorGenerator := self newColorGenerator.

	container :=
		BlElement new
			extent: self logicalExtent;
			addAnimation: (BlBasicAnimation new
				onStepDo: [ :target | target background: backgroundColorGenerator next ];
				yourself);
			yourself.

	"static"
	staticComplexElement := BlElement new
		background: Color transparent;
		extent: self layerExtent;
		yourself.
	1 to: self numberOfFigures do: [ :index |
		staticComplexElement addChild: (self newFigure: random) ].
	container addChild: staticComplexElement.
	
	useSingleComposition 
		ifTrue: [ staticComplexElement beInSingleCompositionLayer ].
		
	^ container
]

{ #category : #hook }
BlBCompositionCase >> newFigure: random [
	
	^ BlElement new
		background: (Color random: random);
		position: (self nextLocation: random);
		extent: self figureExtent;
		yourself
]

{ #category : #accessing }
BlBCompositionCase >> spaceExtent [

	^ self logicalExtent
]

{ #category : #accessing }
BlBCompositionCase >> useSingleComposition: aBoolean [ 
	useSingleComposition := aBoolean
]
