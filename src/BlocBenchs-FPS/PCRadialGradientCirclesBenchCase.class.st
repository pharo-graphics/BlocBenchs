"
I'm a bench case for radial gradients.

See my superclass comment.
"
Class {
	#name : 'PCRadialGradientCirclesBenchCase',
	#superclass : 'PCGradientCirclesBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'instance creation' }
PCRadialGradientCirclesBenchCase >> newGradient: random [

	^ BlRadialGradientPaint new
		center: self radius;
		radius: self radius x;
		stops: (self newStops: random);
		yourself.
]
