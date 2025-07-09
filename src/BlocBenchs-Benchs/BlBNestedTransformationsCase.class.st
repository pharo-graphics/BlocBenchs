Class {
	#name : #BlBNestedTransformationsCase,
	#superclass : #BlBBlocCase,
	#traits : 'TBlBNestedTransformationsLogic',
	#classTraits : 'TBlBNestedTransformationsLogic classTrait',
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #hook }
BlBNestedTransformationsCase >> newElement [

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
			extent: self figureExtent;
			addAnimation: anAnimation;
			yourself ].

	"Nest the figures"
	elements reduceRight: [:a :b | a addChild: b ].

	"Only the first figure element needs to be added to the root of the space."
	^ elements first
		position: self figureOffset;
		yourself
]
