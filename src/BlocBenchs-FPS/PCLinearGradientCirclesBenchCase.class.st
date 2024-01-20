"
I'm a bench case for linear gradients.

See my superclass comment.
"
Class {
	#name : #PCLinearGradientCirclesBenchCase,
	#superclass : #PCGradientCirclesBenchCase,
	#category : #'BlocBenchs-FPS-Cases'
}

{ #category : #hook }
PCLinearGradientCirclesBenchCase >> newGradient: random [

	^ BlLinearGradientPaint new
		start: 0 asPoint;
		end: 2 * self radius;
		stops: (self newStops: random);
		yourself.
]
