Class {
	#name : #BlBLinearGradientCirclesCase,
	#superclass : #BlBAbstractGradientCirclesCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #hook }
BlBLinearGradientCirclesCase >> newGradient: random [

	^ BlLinearGradientPaint new
		start: 0 asPoint;
		end: 2 * self radius;
		stops: (self newStops: random);
		yourself.
]
