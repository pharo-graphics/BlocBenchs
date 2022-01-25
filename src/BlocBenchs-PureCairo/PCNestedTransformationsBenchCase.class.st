Class {
	#name : #PCNestedTransformationsBenchCase,
	#superclass : #PCBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
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

{ #category : #accessing }
PCNestedTransformationsBenchCase >> numberOfFigures [

	^ 50
]

{ #category : #accessing }
PCNestedTransformationsBenchCase >> surfaceExtent [

	^ 750 @ 750
]

{ #category : #accessing }
PCNestedTransformationsBenchCase >> targetRelativeRotation [

	^ 5.0
]

{ #category : #accessing }
PCNestedTransformationsBenchCase >> targetRelativeScale [

	^ 0.9
]
