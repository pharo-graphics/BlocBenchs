Class {
	#name : #PCDashedBorderCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #accessing }
PCDashedBorderCirclesBenchCase >> borderWidth [

	^ 10
]

{ #category : #hook }
PCDashedBorderCirclesBenchCase >> prepare: anElement with: random [

	anElement border:
		(BlBorder builder
			 paint: (Color random: random);
			 width: self borderWidth;
			 dashArray: { (random nextBetween: 5 and: 50) };
			 dashOffset: (random nextIntegerBetween: 5 and: 50);
			 build)

]
