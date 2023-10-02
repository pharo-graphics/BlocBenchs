Class {
	#name : #PCNestedTransformationsBenchCase,
	#superclass : #PCBenchCase,
	#category : 'BlocBenchs-FPS-Cases'
}

{ #category : #accessing }
PCNestedTransformationsBenchCase >> figureExtent [

	^ 600.0 asPoint
]

{ #category : #hook }
PCNestedTransformationsBenchCase >> figureOffset [

	^ 50.0 asPoint
]

{ #category : #accessing }
PCNestedTransformationsBenchCase >> logicalExtent [

	^ 750 @ 750
]

{ #category : #hook }
PCNestedTransformationsBenchCase >> newElement [

	| elements random anAnimation |
	random := self newRandom.

	"Create each figure with a transform animation."
	elements := (1 to: self numberOfFigures) collect: [ :each |
		
		anAnimation := BlSequentialAnimation new.
		anAnimation add:
			(BlTransformAnimation new 
					absolute;
					transformDo: [ :builder |
						builder
							scaleBy: self targetRelativeScale;
							rotateBy: self targetRelativeRotation ];
					duration: self duration;
					yourself).
		anAnimation add:
			(BlTransformAnimation new 
					absolute;
					transformDo: [ :builder |
						builder
							scaleBy: 1.0;
							rotateBy: 0.0 ];
					duration: self duration;
					yourself).
		anAnimation beInfinite.
			
			
		BlElement new
			clipChildren: false;
			background: (Color random: random);
			size: self figureExtent;
			addAnimation: anAnimation;
			yourself ].

	"Nest the figures"
	elements reduceRight: [:a :b | a addChild: b ].

	"Only the first figure element needs to be added to the root of the space."
	^ elements first
		position: self figureOffset;
		yourself
]

{ #category : #hook }
PCNestedTransformationsBenchCase >> newRawSDLCairoWindow [

	^ PCNestedTransformationsWindow newWith: self
]

{ #category : #accessing }
PCNestedTransformationsBenchCase >> numberOfFigures [

	^ 50
]

{ #category : #accessing }
PCNestedTransformationsBenchCase >> targetRelativeRotation [

	^ 5.0
]

{ #category : #accessing }
PCNestedTransformationsBenchCase >> targetRelativeScale [

	^ 0.9
]
