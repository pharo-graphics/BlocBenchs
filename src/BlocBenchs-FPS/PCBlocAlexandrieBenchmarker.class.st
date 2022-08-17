"
I'm a benchmarker for the Pure Cairo renderer.
"
Class {
	#name : #PCBlocAlexandrieBenchmarker,
	#superclass : #PCBlocBenchmarker,
	#category : #'BlocBenchs-FPS-Benchmarkers'
}

{ #category : #accessing }
PCBlocAlexandrieBenchmarker >> host [

	^ BAOSWindowSDL2Host new
]

{ #category : #accessing }
PCBlocAlexandrieBenchmarker >> label [

	^ 'Bloc Alexandrie'
]
