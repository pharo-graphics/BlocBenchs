Class {
	#name : #BlBGridLayoutForceLayoutingCase,
	#superclass : #BlBBlocCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBGridLayoutForceLayoutingCase >> newElement [

	| container |
	container := BlElement new.
	container layout: (BlGridLayout new columnCount: 3).
	container layout cellSpacing: 3.
	container constraintsDo: [ :c |
		c vertical matchParent.
		c horizontal matchParent ].

	30 timesRepeat: [
		container addChild: (BlElement new
				 background: Color random;
				 height: 50;
				 width: 50;
				 yourself) ].

	container addAnimation: (BlBasicAnimation new
			 onStepDo: [ :target |
				 target children asArray shuffle.
				 target requestLayout ];
			 yourself).
			
	^ container	
]
