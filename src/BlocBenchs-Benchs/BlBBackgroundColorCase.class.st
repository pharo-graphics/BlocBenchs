"
I'm a profiling case with a BlElement that changes background color on each frame with an infinite animation.
"
Class {
	#name : #BlBBackgroundColorCase,
	#superclass : #BlBAbstractSimpleAnimationCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBBackgroundColorCase >> newSteppingAnimation [

	| colorGenerator |
	colorGenerator := Generator on: [ :generator | 
		| nextIndex wheel |
		
		nextIndex := 1.
		wheel := Color wheel: 50.
		[ generator yield: (wheel at: nextIndex).
		nextIndex := (nextIndex + 1) \\ wheel size + 1 ] repeat ].

	^ BlNumberTransition new
		  from: 0;
		  to: 1;
		  onStepDo: [ :t :element |
			element background: colorGenerator next ];
		  beInfinite;
		  yourself
]
