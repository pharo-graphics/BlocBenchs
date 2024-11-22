"
I'm a profiling case with a BlElement that translates during a period of time.
"
Class {
	#name : #BlBTranslateCase,
	#superclass : #BlBAbstractSimpleAnimationCase,
	#category : #'BlocBenchs-Benchs-Bloc'
}

{ #category : #'instance creation' }
BlBTranslateCase >> newSteppingAnimation [

	^ (BlTransformAnimation translate: 0@200)
		  duration: self duration;
		  yourself
]
