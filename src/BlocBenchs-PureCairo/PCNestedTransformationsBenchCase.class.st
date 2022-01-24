Class {
	#name : #PCNestedTransformationsBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCNestedTransformationsBenchCase >> figureExtent [

	^ 600.0 asPoint
]

{ #category : #hook }
PCNestedTransformationsBenchCase >> newElement [

	| elements random |
	random := self newRandom.

	"Create each figure with a transform animation."
	elements := (1 to: self numberOfFigures) collect: [ :each |
		BlElement new
			background: (Color random: random);
			size: self figureExtent;
			addAnimation: (BlTransformAnimation new 
				transformDo: [ :builder |
					builder
						scaleBy: self targetRelativeScale;
						rotateBy: self targetRelativeRotation ];
				duration: self duration;
				yourself);
			yourself ].

	"Nest the figures"
	elements reduceRight: [:a :b | a addChild: b ].

	"Only the first figure element needs to be added to the root of the space."
	^ elements first
		relocate: 100 asPoint;
		yourself
]

{ #category : #hook }
PCNestedTransformationsBenchCase >> numberOfFigures [

	^ 50
]

{ #category : #hook }
PCNestedTransformationsBenchCase >> surfaceExtent [

	^ 800 @ 800
]

{ #category : #hook }
PCNestedTransformationsBenchCase >> targetRelativeRotation [

	^ 1.0
]

{ #category : #hook }
PCNestedTransformationsBenchCase >> targetRelativeScale [

	^ 0.95
]
