Class {
	#name : 'PCTranslucentOpacityCirclesBenchCase',
	#superclass : 'PCCirclesBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'hook' }
PCTranslucentOpacityCirclesBenchCase >> prepare: anElement with: random [

	anElement
		background: (Color random: random);
		opacity: 0.5.
]
