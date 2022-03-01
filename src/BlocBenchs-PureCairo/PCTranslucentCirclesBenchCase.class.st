Class {
	#name : #PCTranslucentCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCTranslucentCirclesBenchCase >> prepare: anElement with: random [

	anElement background: ((Color random: random) alpha: 0.1)
]
