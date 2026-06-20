Class {
	#name : #PCTranslucentOpacityCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCTranslucentOpacityCirclesBenchCase >> prepare: anElement with: random [

	anElement
		background: (Color blbRandom: random);
		opacity: 0.5.
]
