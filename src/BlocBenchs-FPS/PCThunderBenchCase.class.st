Class {
	#name : #PCThunderBenchCase,
	#superclass : #PCPolylineBenchCase,
	#category : #'BlocBenchs-FPS'
}

{ #category : #hook }
PCThunderBenchCase >> vertices [

	^ (Array streamContents: [:stream |
			stream << (0@0).
			0 to: 10 do: [ :index |
				stream << (50 @ (index * 10)).
				stream << (0 @ ((index + 1) * 10)) ] ])
]
