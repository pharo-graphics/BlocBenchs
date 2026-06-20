Class {
	#name : #PCTranslucentCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCTranslucentCirclesBenchCase >> prepare: anElement with: random [

	anElement background: ((Color blbRandom: random) alpha: 0.1)
]
