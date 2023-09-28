Class {
	#name : 'PCHexagonBenchCase',
	#superclass : 'PCPolylineBenchCase',
	#category : 'BlocBenchs-FPS-Cases',
	#package : 'BlocBenchs-FPS',
	#tag : 'Cases'
}

{ #category : 'hook' }
PCHexagonBenchCase >> vertices [ 

	^ { 
		 60 @  0.
		 20 @  0.
		  0 @ 36.
		 20 @ 70.
		 60 @ 70.
		 80 @ 36 }
]
