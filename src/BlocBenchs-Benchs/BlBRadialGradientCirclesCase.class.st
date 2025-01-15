Class {
	#name : #BlBRadialGradientCirclesCase,
	#superclass : #BlBAbstractGradientCirclesCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBRadialGradientCirclesCase >> newGradient: random [

	^ BlRadialGradientPaint new
		center: self radius;
		radius: self radius x;
		stops: (self newStops: random);
		yourself.
]
