Class {
	#name : #PCHexagonBenchCase,
	#superclass : #PCPolylineBenchCase,
	#category : #'BlocBenchs-PureCairo'
}

{ #category : #hook }
PCHexagonBenchCase >> preparePolyline: anElement [

	anElement geometry:
		(BlPolylineGeometry vertices: { 
			 60 @  0.
			 20 @  0.
			  0 @ 36.
			 20 @ 70.
			 60 @ 70.
			 80 @ 36 })

]
