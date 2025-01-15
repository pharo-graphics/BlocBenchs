Class {
	#name : #BlBDashedBorderCirclesCase,
	#superclass : #BlBAbstractCircleCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #accessing }
BlBDashedBorderCirclesCase >> borderWidth [

	^ 10
]

{ #category : #hook }
BlBDashedBorderCirclesCase >> prepare: anElement with: random [

	anElement border:
		(BlBorder builder
			 paint: (Color random: random);
			 width: self borderWidth;
			 dashArray: { (random nextBetween: 5 and: 50) };
			 dashOffset: (random nextIntegerBetween: 5 and: 50);
			 build)

]
