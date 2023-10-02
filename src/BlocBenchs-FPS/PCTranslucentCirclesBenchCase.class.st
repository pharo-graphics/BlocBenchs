Class {
	#name : #PCTranslucentCirclesBenchCase,
	#superclass : #PCCirclesBenchCase,
	#category : 'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCTranslucentCirclesBenchCase >> prepare: anElement with: random [

	anElement background: ((Color random: random) alpha: 0.1)
]
